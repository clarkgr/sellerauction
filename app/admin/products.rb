ActiveAdmin.register Product do

  filter :category
  filter :name
  filter :description
  filter "stocks_price_gt", :as => :number, :label => "Search minimum price"
  filter "stocks_price_lt", :as => :number, :label => "Search maximum price"
  
  config.clear_action_items!
  
  action_item do
    link_to "New product", new_resource_path if current_user.type.blank?
  end
  
  action_item :only => [:show, :edit, :create, :update] do
    link_to "Edit product", edit_resource_path if current_user.type.blank?
  end
  
  action_item :only => [:show, :edit, :create, :update] do
    link_to "Delete product", resource_path if current_user.type.blank?
  end
  
  index :as => :grid do |product|
    div :class => "grid_product" do
      div :class => "half_first_floater" do
        div :class => "image" do image_tag product.image_url(:thumb) end
        div :class => "name"  do link_to product.name, resource_path(product) end
      end
      div :class => "half_second_floater" do
        div :class => "sellers" do
          "Available by these sellers: #{product.sellers.map{ |n| link_to n.name, seller_path(n)}.join(", ")}".html_safe
        end
        div :class => "price" do
          "From: #{number_to_currency product.min_price}"
        end
        div :class => "start" do
          if current_user.type == "Buyer"
            link_to "I want this!", new_interest_path(:product_id => product.id), :class => "mybutton want_this_link"
          elsif current_user.type == "Seller"
            if stock = current_user.has_product?(product)
              link_to "Edit price and/or quantity", edit_stock_path(stock), :class => "mybutton"
            else
              link_to "Sell this!", new_stock_path(:product_id => product.id), :class => "mybutton"
            end
          end
        end
      end
    end
  end
  
  show :title => lambda { |_| resource.name } do
    attributes_table_for resource do
      row :image do
        span do image_tag resource.image, :height => 200, :style => "vertical-align:middle;" end
        span do 
          link_to "#{image_tag("want_this.png")} I want this!".html_safe,
                  new_interest_path(:product_id => product.id), :class => "want_this_link"
        end if can?(:create, Interest)
      end
      row :description
      row "In stock" do
        current_user.has_product?(product).quantity if current_user.has_product?(product)
      end if current_user.type == "Seller"
    end
    table_for resource.stocks.order(:price) do
      column :seller
      column :price
    end
  end
  
  form do |f|
    f.inputs do
      f.input :category
      f.input :code, :input_html => {:disabled => true}
      f.input :name
      f.input :description
      f.input :image, :hint => f.object.persisted? && f.object.image.present? ? image_tag(f.object.image_url(:thumb)) : ""
      f.input :image_cache, :as => :hidden
    end
    f.buttons
  end
  
  controller do
    load_and_authorize_resource :except => :index
    
    def update
      update! do
        redirect_to action: "index" and return
      end
    end
    
    protected
    
    def scoped_collection
      end_of_association_chain.accessible_by(current_ability).joins{ :sellers }.includes{ sellers }.group{ products.id }.
        select{ [products.id, products.name, products.image, min(stocks.price).as(min_price), max(stocks.price).as(max_price)]}
    end
  end
  
end
