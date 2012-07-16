class Buyer < User
  # attr_accessible :title, :body
  
  has_many :interests, :foreign_key => :user_id
  has_many :orders, :foreign_key => :user_id
  
end
