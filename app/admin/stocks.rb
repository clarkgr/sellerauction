ActiveAdmin.register Stock do

  menu :if => Proc.new{ |_| can? :read, Stock }
  
  filter "product_name", :as => :string
  filter :price
  filter :quantity
  filter :updated_at
  
  index do
    column do |stock|
      image_tag stock.product.image_url(:thumb)
    end
    column :product
    column :price
    column :quantity
    default_actions
  end
  
  form do |f|
    f.inputs "Details: #{resource.product.name}" do
      f.input :product_id, :as => :hidden
      f.input :price
      f.input :quantity
    end
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
    actions :all, :except => [:show]
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
      end_of_association_chain.accessible_by(current_ability)
    end
  end
  
end
