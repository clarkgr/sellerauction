ActiveAdmin.register Seller do
  
  filter :name
  filter :email
  
  index :as => :grid do |seller|
    div :class => "grid_seller" do
      div :class => "half_first_floater" do
        # div :class => "image" do image_tag seller.image_url(:thumb) end
        div :class => "name"  do link_to seller.name, can?(:update, seller) ? edit_resource_path(seller) : resource_path(seller) end
      end
    end
  end
  
  show do
    panel resource.name
    div :class => "seller_page" do
      div :class => "logo" do
        image_tag resource.logo rescue nil
      end
    end
  end
  
  form do |f|
    f.inputs "Details: #{resource.name}" do
      f.input :name
      f.input :password
      f.input :password_confirmation
    end
    f.buttons
  end
  
  controller do
    load_and_authorize_resource :except => :index
    
    def scoped_collection
      end_of_association_chain.accessible_by(current_ability)
    end
  end
  
end
