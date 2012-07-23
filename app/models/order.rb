class Order < ActiveRecord::Base
  attr_accessible :paid_at, :price, :interest_id, :seller_id, :shipped_at, :user_id
  
  before_validation :update_seller_stock
  before_save :update_details
  
  belongs_to :user
  belongs_to :seller
  belongs_to :interest
  has_one    :product, :through => :interest

  validates :interest_id, :seller_id, :user_id, :presence => true
  
  def product_name
    interest.product.name
  end
  
  def update_details
    if persisted?
      self.seller_id = seller_id_was
      self.interest_id = interest_id_was
      self.user_id = user_id_was
    end
    self.price = interest.current_price
    if paid_at_changed? && paid_at_was.nil? && !paid_at.blank?
      stock.decrement! :quantity, interest.quantity if stock
    end
  end
  
  def stock
    @stock = seller.has_product?(interest.product)
  end

  def update_seller_stock
    if stock && stock.quantity < interest.quantity
      errors.add :base, "Insufficient quantity from seller!"
    end
  end
  
end
