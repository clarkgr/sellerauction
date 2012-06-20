class Stock < ActiveRecord::Base
  
  belongs_to :seller
  belongs_to :product
  
  attr_accessible :price, :quantity
end
