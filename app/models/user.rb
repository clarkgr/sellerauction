class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  before_create :select_type
  
  def select_type
    self.type ||= "Buyer"
  end
  
  def name_or_email
    name.to_s.strip.blank? ? email : name
  end
  
end
