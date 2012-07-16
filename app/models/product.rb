class Product < ActiveRecord::Base
  
  before_create :update_code
  
  belongs_to :category
  has_many :interests
  has_many :stocks
  has_many :sellers, :through => :stocks
  
  attr_accessible :code, :name, :description, :category, :category_id, :image, :image_cache
  
  mount_uploader :image, ImageUploader
  
  def update_code
    self.code = Digest::MD5.hexdigest(name)
  end
  
  def min_available_price
    stocks.minimum(:price)
  end
  
  def price_for(seller)
    stocks.where{seller_id == seller.id}.first.try(:price)
  end
  
end
