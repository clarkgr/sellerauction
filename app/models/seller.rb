class Seller < User
  # attr_accessible :title, :body

  has_many :stocks
  has_many :products, :through => :stocks
  has_many :bids
  
  def has_product?(product)
    stocks.where{product_id == product.id}.first
  end
  
end
