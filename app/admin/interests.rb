ActiveAdmin.register Interest do
  
  form do |f|
    f.inputs "Interest details" do
      f.input :start_price
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
    div do image_tag @product.image, :height => 200, :style => "vertical-align:middle;" end
    div do truncate @product.description, :length => 80, :separator => " " end
    div do link_to "More", @product end
  end
    
  sidebar "Product details", :only => [:new, :edit, :create, :update] do
    table_for @product.stocks.order(:price) do
      column :seller
      column :price
    end
  end

  controller do
    
    def new
      new!
      @product = Product.find_by_id params[:product_id]
      logger.debug @product.inspect
    end
    
    def create
      @product = Product.find_by_id params[:product_id]
      create!
    end
    
    def update
      @product = Product.find_by_id params[:product_id]
      update!
    end
    
  end
  
end
