class User < ActiveRecord::Base

  attr_accessor :password
  attr_accessible :name, :password, :password_confirmation, :permissions

  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
 
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.crypted_password = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.authenticate(name, password)
    user = find_by_name(name)
    if user && user.crypted_password == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
end
