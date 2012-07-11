class Interest < ActiveRecord::Base
  attr_accessible :start_price, :decrements, :expires_at
  
  belongs_to :product
  belongs_to :user
  belongs_to :seller
  
  validates :product, :user, :start_price, :expires_at, :presence => true
  validates :start_price, :numericality => true
  
end
