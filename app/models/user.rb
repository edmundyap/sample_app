class User < ActiveRecord::Base
	attr_accessor :remember_token
	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },  format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false }
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }

	def User.digest(string)
  	cost = ActiveModel::SecurePassword.min_cost ?	BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
  	SecureRandom.urlsafe_base64
  	#creates the remember digest token.
  	#Since token doesn't need a user object, it is created as a class method.
  end

  def remember
    self.remember_token = User.new_token 
    #associates a remember token with the user and saves the corresponding remember digest to the database. Since, remember digest is a method as defined in the attribute accessor method, self. would mean that the writer method is called on the object User itself. 
    update_attribute(:remember_digest, User.digest(remember_token))
    #update attribute for updating existing model in the database. 
  end

  def authenticated?(remember_token)
  	return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end

