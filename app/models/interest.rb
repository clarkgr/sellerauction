class Interest < ActiveRecord::Base
  attr_accessible :product_id, :max_buying_price, :decrements, :expires_at
  
  before_save :update_current_price
  
  belongs_to :product
  belongs_to :user
  has_many   :bids
  belongs_to :order
  
  validates :product, :user, :max_buying_price, :expires_at, :presence => true
  validates :max_buying_price, :numericality => {:less_than => lambda { |x| x.product.min_available_price }}
  validates :decrements, :numericality => {:greater_than_or_equal_to => 0.01,
            :less_than_or_equal_to => lambda { |x| x.max_buying_price.to_s.to_f / 10.0 }}
  validate  :expires_at_must_be_in_the_future, :if => :expires_at_changed?
  
  def expires_at_must_be_in_the_future
    errors.add(:expires_at, "must be in the future") if expires_at.nil? || expires_at.past?
  end
  
  def won?
    current_price <= max_buying_price && expires_at.past?
  end
  
  def update_current_price
    ibids = bids.order(:min_price).all
    self.current_price = if ibids.length == 0
      product.min_available_price
    elsif ibids.length == 1
      ibids[0].min_price <= max_buying_price ? max_buying_price : product.min_available_price
    else
      best_price = [ibids[1].min_price - decrements, ibids[0].min_price].max
      best_price <= max_buying_price ? best_price : product.min_available_price
    end
  end
  
end
