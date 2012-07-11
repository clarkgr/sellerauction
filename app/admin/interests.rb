ActiveAdmin.register Interest do
  
  form do |f|
    f.inputs "Interest details" do
      f.input :start_price
    end
  end
  
  sidebar "Product image", :only => [:new, :edit] do
    div do image_tag resource.product.image, :height => 200, :style => "vertical-align:middle;" end
    div do truncate resource.product.description, :length => 80, :separator => " " end
    div do link_to "More", resource.product end
  end
    
  sidebar "Product details", :only => [:new, :edit] do
    table_for resource.product.stocks.order(:price) do
      column :seller
      column :price
    end
  end

  controller do
    
    def new
      new! do
        resource.product_id = params[:product_id]
      end
    end
    
  end
  
end
