ActiveAdmin.register Category do
  
  menu :if => Proc.new{ |_| current_user.type.blank? }
  
  controller do
    load_and_authorize_resource :except => :index

    def scoped_collection
      end_of_association_chain.accessible_by(current_ability)
    end
  end
  
end
