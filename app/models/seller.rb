class Seller < User
  # attr_accessible :title, :body

  has_many :stocks
  has_many :products, :through => :stocks
  has_many :bids
  
end
