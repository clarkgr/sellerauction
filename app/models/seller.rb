class Seller < User

  has_many :stocks
  has_many :products, :through => :stocks
  
  # attr_accessible :title, :body
end
