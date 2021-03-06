ActiveAdmin.register Seller do
  
  filter :name
  filter :email
  
  index :as => :grid do |seller|
    div :class => "grid_seller" do
      div :class => "" do
        div :class => "image" do image_tag seller.avatar_url(:thumb) end
        div :class => "name"  do link_to seller.name, can?(:update, seller) ? edit_resource_path(seller) : resource_path(seller) end
        div :class => "address"  do seller.address end
      end
    end
  end
  
  show do
    panel resource.name do
      div :class => "image" do image_tag seller.avatar_url(:thumb) end
      div :class => "name"  do link_to seller.name, can?(:update, seller) ? edit_resource_path(seller) : resource_path(seller) end
      div :class => "address"  do seller.address end
    end
  end
  
  form do |f|
    f.inputs "Details: #{resource.name}" do
      f.input :name
      f.input :password
      f.input :password_confirmation
    end
    f.inputs "Logo and address" do
      f.input :avatar, :label => "Logo"
      f.input :address
    end
    f.buttons
  end
  
  controller do
    load_and_authorize_resource :except => :index
    
    def update
      params[:seller].delete(:password) && params[:seller].delete(:password_confirmation) if params[:seller] && params[:seller][:password].blank?
      update!
    end
    
    protected 
    
    def scoped_collection
      end_of_association_chain.accessible_by(current_ability)
    end
  end
  
end
