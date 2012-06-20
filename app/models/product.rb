class Product < ActiveRecord::Base
  
  belongs_to :category
  has_many :stocks
  has_many :sellers, :through => :stocks
  
  attr_accessible :code, :name, :description, :category, :category_id, :image, :image_cache
  
  mount_uploader :image, ImageUploader
end
