class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.type.blank?
      can :manage, Product
      can :manage, Category
    else
      can :read, [Product, Seller]
      if user.type == "Seller"
        can :manage,      Stock     , :seller_id => user.id
        can :create,      Stock
        can :read,        Interest  , :product_id => user.product_ids
        can :manage,      Bid       , :seller_id => user.id
        can :create,      Bid
        can :read,        Order     , :seller_id => user.id
        can :update,      Order     , :seller_id => user.id
      end
      if user.type == "Buyer"
        can :manage,      Interest  , :user_id => user.id
        can :create,      Interest
        can :read,        Bid       , :interest_id => user.interest_ids
        can :read,        Order     , :user_id => user.id
        can :create,      Order 
      end
      can :manage,        User      , :id => user.id
    end

    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
