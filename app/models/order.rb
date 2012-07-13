class Order < ActiveRecord::Base
  attr_accessible :paid_at, :price, :product_id, :seller_id, :shipped_at, :user_id
  
  belongs_to :user
  belongs_to :seller
  belongs_to :product
end
