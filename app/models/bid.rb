class Bid < ActiveRecord::Base
  attr_accessible :interest_id, :min_price, :seller_id
  
  before_validation :update_interest_current_price
  after_save        :update_interest_current_price
  
  belongs_to :interest
  belongs_to :seller
  has_one :product, :through => :interest
  has_one :user, :through => :interest
  
  validates :min_price, :presence => true,
            :numericality => {:less_than => lambda { |x| [x.interest.current_price, x.interest.max_buying_price].min }}
  validates :interest_id, :uniqueness => {:scope => :seller_id, :message => "! You have already placed a bid for this !" }

  delegate :expires_at, :expired?, :to => :interest
  
  def update_interest_current_price
    interest.save!
    true
  end
  
  def winning?
    min_price <= interest.current_price
  end
  
  
end
