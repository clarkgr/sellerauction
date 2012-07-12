ActiveAdmin.register Interest do
  
  filter "product_name", :as => :string
  filter :start_price
  filter :current_price
  filter :seller
  filter :expires_at
  filter :updated_at
  
  action_item :only => [:index] do
    link_to "View as #{params[:as_seller].blank? ? "seller" : "buyer"}", {:as_seller => params[:as_seller].blank? ? 1 : nil}
  end
  
  index do
    column :user if !params[:as_seller].blank?
    column :product
    column :start_price
    column :current_price
    column :seller
    column :expires_at
    column :updated_at if params[:as_seller].blank?
    column do |interest|
      link_to "Place bid!", new_bid_path(:interest_id => interest.id)
    end if !params[:as_seller].blank?
  end
  
  form do |f|
    f.inputs "Interest details" do
      f.input :product_id, :as => :hidden, :input_html => {:value => f.object.product_id || params[:product_id]}
      f.input :start_price, :max => f.object.product.min_available_price
      f.input :decrements
      f.input :expires_at, :as => :datepicker
    end
    f.inputs "Progess" do
      f.input :current_price, :input_html => {:disabled => true}
      f.input :seller, :as => :string, :input_html => {:disabled => true}
    end if f.object.persisted?
    f.buttons
  end
  
  sidebar "Product image", :only => [:new, :edit, :create, :update] do
    div do image_tag resource.product.image, :height => 200, :style => "vertical-align:middle;" end
    div do truncate resource.product.description, :length => 80, :separator => " " end
    div do link_to "More", resource.product end
  end
    
  sidebar "Product details", :only => [:new, :edit, :create, :update] do
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
        @interest.product_id = params[:product_id]
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
      collection = end_of_association_chain.accessible_by(current_ability).includes(:product, :seller)
      if params[:as_seller].blank?
        collection = collection.where(:user_id => current_user.id)
      else
        visible_product_ids = current_user.type == "Seller" ? current_user.product_ids : []
        collection = collection.where(:product_id => visible_product_ids)
      end
      collection
    end
    
  end
  
end
