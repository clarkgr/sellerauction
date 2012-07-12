class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.type.blank?
      can :manage, :all
    else
      can :read, [Product, Seller, Stock]
      if user.type == "Seller"
        can :manage,      Stock     , :seller_id => user.id
        can :create,      Stock
        can :manage,      Seller    , :id => user.id
        cannot :destroy,  Seller
        can :read,        Interest  , :product_id => user.product_ids
        can :manage,      Bid       , :seller_id => user.id
        can :create,      Bid
      end
      can :manage,        Interest  , :user_id => user.id
      can :create,        Interest
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
