ActiveAdmin.register Bid do
  
  index do
    column :product
    column :user
    column :min_price
    column :current_price do |bid|
      bid.interest.current_price
    end
  end
  
  form :partial => "form.erb"
  
  sidebar "Product details", :only => [:new, :edit, :create, :update] do
    div do image_tag resource.product.image, :height => 200, :style => "vertical-align:middle;" end
    div do truncate resource.product.description, :length => 80, :separator => " " end
    div do link_to "More", resource.product end
  end
  
  sidebar "Bids", :only => [:new, :edit, :create, :update] do
    attributes_table_for resource.interest do
      row :current_price
      row :total_bidders do
        resource.interest.bids.count
      end
    end
  end
  
  controller do
    load_and_authorize_resource :except => :index

    def past_orders
      @past_orders ||= Order.where(:user_id => resource.interest.user_id, :seller_id => current_user)
    end
    helper_method :past_orders

    def new
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
      end_of_association_chain.accessible_by(current_ability)
    end
    
  end
  
  
end
