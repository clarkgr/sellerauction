class Order < ActiveRecord::Base
  attr_accessible :paid_at, :price, :product_id, :seller_id, :shipped_at, :user_id
end
