ActiveAdmin.register Buyer do
  
  menu false
  
  filter :name
  filter :email
  
  show do
    panel resource.name
    div :class => "user_page" do
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
    
    def index
      redirect_to user_url(current_user)
    end
    
    def update
      params[:buyer].delete(:password) && params[:buyer].delete(:password_confirmation) if params[:buyer] && params[:buyer][:password].blank?
      update!
    end
    
    def scoped_collection
      end_of_association_chain.accessible_by(current_ability)
    end
  end
  
end
