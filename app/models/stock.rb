class Stock < ActiveRecord::Base
  attr_accessible :price, :quantity, :product_id
  
  belongs_to :seller
  belongs_to :product
  
  before_validation :update_interest_current_price
  
  def update_interest_current_price
    product.interests.each(&:save)
  end
  
end
