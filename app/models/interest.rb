class Interest < ActiveRecord::Base
  attr_accessible :expires_at, :product_id, :user_id
  
  belongs_to :product
  belongs_to :user
  belongs_to :seller
  
end
