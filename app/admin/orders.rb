ActiveAdmin.register Order do

  filter "product_name", :as => :string
  filter :price
  filter :paid_at
  filter :shipped_at
  
  index do
    column :user if current_user.type == "Seller"
    column :seller if current_user.type == "Buyer"
    column :product
    column :price
    column :paid_at
    column :shipped_at
    default_actions
  end
  
  show do
    panel "Order details" do
      attributes_table_for resource do
        row :user
        row :seller
        row :product
        row :price
        row :paid_at do
          if resource.paid_at?
            I18n.l resource.paid_at
          else
            link_to "Pay now!"
          end
        end
        row :shipped_at
        row :created_at
      end
    end
    active_admin_comments
  end
  
  form :partial => "form"
  
  sidebar "Product image", :only => [:new, :show, :edit, :create, :update] do
    div do image_tag resource.product.image, :height => 200, :style => "vertical-align:middle;" end
    div do truncate resource.product.description, :length => 80, :separator => " " end
    div do link_to "More", resource.product end
  end
    
  sidebar "Actual prices", :only => [:new, :show, :edit, :create, :update] do
    table_for resource.product.stocks.order(:price) do
      column :seller
      column :price
      column "You saved" do |stock|
        number_to_percentage resource.interest.current_price / stock.price * 100, :precision => 0
      end
    end
  end
  
  controller do
    load_and_authorize_resource :except => :index
    
    def new
      redirect_to interests_url, :alert => "Select a won interest first!" and return if params[:interest_id].blank?
      new! do
        resource.interest_id = params[:interest_id]
        resource.price = resource.interest.current_price
      end
    end
    
    def update
      params[:order].delete(:paid_at) && params[:order].delete(:shipped_at) if params[:order] && current_user.type != "Seller"
      update!
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
      collection = end_of_association_chain.accessible_by(current_ability).includes(:product).includes(:seller)
      if current_user.type == "Buyer"
        collection = collection.where(:user_id => current_user.id)
      elsif current_user.type == "Seller"
        collection = collection.where(:seller_id => current_user.id)
      end
      collection
    end
    
  end
  
end
