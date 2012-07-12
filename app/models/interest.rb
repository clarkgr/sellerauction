class Interest < ActiveRecord::Base
  attr_accessible :product_id, :start_price, :decrements, :expires_at
  
  before_save :update_current_price
  
  belongs_to :product
  belongs_to :user
  belongs_to :seller
  has_many   :bids
  
  validates :product, :user, :start_price, :expires_at, :presence => true
  validates :start_price, :numericality => {:less_than => lambda { |x| x.product.min_available_price }}
  validates :decrements, :numericality => {:greater_than => 0}
  validate  :expires_at_must_be_in_the_future
  
  def expires_at_must_be_in_the_future
    errors.add(:expires_at, "must be in the future") if expires_at.nil? || expires_at.past?
  end
  
  def update_current_price
    bids_minimum_price = bids.where("min_price != #{bids.minimum(:min_price)}").order(:min_price).minimum(:min_price)
    logger.debug "updating current price... #{bids_minimum_price.inspect}"
    self.current_price = [(bids_minimum_price || product.min_available_price) - decrements, product.min_available_price].min
  end
  
end
