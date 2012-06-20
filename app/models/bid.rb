class Bid < ActiveRecord::Base
  attr_accessible :interest_id, :min_price, :seller_id
end
