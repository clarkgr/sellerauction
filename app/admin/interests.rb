ActiveAdmin.register Interest do
  
  
  form do |f|
    f.inputs do
      div :class => "grid_product" do
        div :class => "half_first_floater" do
          div :class => "image" do image_tag f.object.product.image_url(:thumb) end
          div :class => "name"  do link_to f.object.product.name, resource_path(f.object.product) end
        end
        div :class => "half_second_floater" do
          div :class => "sellers" do
            "Available by these sellers: #{f.object.product.sellers.map{ |n| link_to n.name, seller_path(n)}.join(", ")}".html_safe
          end
        end
      end
    end
    f.inputs do
      f.input :start_price
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
