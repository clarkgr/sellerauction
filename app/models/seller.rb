class Seller < User

  has_many :stocks
  has_many :products, :through => :stocks
  has_many :bids
  # attr_accessible :title, :body
end
