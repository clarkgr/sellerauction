ActiveAdmin.register Product do

  filter :category
  filter :name
  filter :description
  filter "stocks_price_gt", :as => :number, :label => "Search minimum price"
  filter "stocks_price_lt", :as => :number, :label => "Search maximum price"
  
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
          link_to "#{image_tag("want_this.png")} I want this!".html_safe,
                  new_interest_path(:product_id => product.id), :class => "want_this_link"
        end
      end
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
