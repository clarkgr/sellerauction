ActiveAdmin.register Interest do
  
  filter "product_name", :as => :string
  filter :max_buying_price
  filter :current_price
  filter :expires_at
  
  config.clear_action_items!
  
  action_item :only => [:show, :edit] do
    link_to "Edit", edit_resource_path
  end

  action_item :only => [:show, :edit] do
    link_to "Delete", resource_path, :method => :delete, :confirm => "Are you sure?"
  end
  
  index do
    column :user if current_user.type == "Seller"
    column :product
    column :max_buying_price
    column :current_price
    column :expires_at
    column do |interest|
      if current_user.type == "Seller"
        bid = current_user.bids.where{interest_id == my{interest.id}}.first
        if bid.nil?
          link_to "Place bid!", new_bid_path(:interest_id => interest.id)
        else
          link_to "Details", bid_path(bid)
        end
      else
        html = ""
        html << link_to("Details", resource_path(interest))
        html << "<br/>" << link_to("Place order", new_order_path(:interest_id => interest.id)) if interest.won?
        html.html_safe
      end
    end 
  end
  
  show :title => lambda { |x| "Interest details for #{x.product.name}" } do
    panel "Details" do
      attributes_table_for resource do
        row :expires_at
        row :max_buying_price
        row :decrements
        row :current_price
      end
    end
    panel "Bids" do
      attributes_table_for resource do
        row :total_bids do
          resource.bids.count
        end
        row :bidders do
          resource.bids.includes{seller}.map{ |b| link_to b.seller.name, b.seller }.join(", ").html_safe
        end
      end
    end
  end
  
  form do |f|
    f.inputs "Interest details" do
      f.input :product_id, :as => :hidden, :input_html => {:value => f.object.product_id || params[:product_id]}
      f.input :max_buying_price, :max => f.object.product.min_available_price
      f.input :decrements
      f.input :expires_at, :as => :datepicker
    end
    f.inputs "Progess" do
      f.input :current_price, :input_html => {:disabled => true}
    end if f.object.persisted?
    f.buttons
  end
  
  sidebar "Product image", :only => [:new, :show, :edit, :create, :update] do
    div do image_tag resource.product.image, :height => 200, :style => "vertical-align:middle;" end
    div do truncate resource.product.description, :length => 80, :separator => " " end
    div do link_to "More", resource.product end
  end
    
  sidebar "Product details", :only => [:new, :show, :edit, :create, :update] do
    table_for resource.product.stocks.order(:price) do
      column :seller
      column :price
    end
  end

  controller do
    load_and_authorize_resource :except => :index
    
    def new
      redirect_to products_url, :alert => "Select a product first!" and return if params[:product_id].blank?
      new! do
        resource.product_id = params[:product_id]
      end
    end
    
    protected

    def begin_of_association_chain
      if action_name == "create"
        current_user
      else
        super
      end
    end
    
    def scoped_collection
      collection = end_of_association_chain.accessible_by(current_ability).includes(:product)
      if current_user.type == "Buyer"
        collection = collection.where(:user_id => current_user.id)
      elsif current_user.type == "Seller"
        collection = collection.where(:product_id => current_user.product_ids)
      end
      collection
    end
    
  end
  
end
