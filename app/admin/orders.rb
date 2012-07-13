ActiveAdmin.register Order do
  
  controller do
    load_and_authorize_resource :except => :index
    
    def new
      redirect_to interests_url, :alert => "Select a won interest first!" and return if params[:interest_id].blank?
      new! do
        resource.interest_id = params[:interest_id]
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
