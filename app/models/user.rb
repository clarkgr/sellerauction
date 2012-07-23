class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :avatar, :address

  before_create :select_type
  
  mount_uploader :avatar, ImageUploader
  
  def select_type
    self.type ||= "Buyer"
  end
  
  def name_or_email
    name.to_s.strip.blank? ? email : name
  end
  
end
