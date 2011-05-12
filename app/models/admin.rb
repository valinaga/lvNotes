class Admin < ActiveRecord::Base
  
  validates :username, :email, :presence => true, :uniqueness => true
  validates :email, :email_format => true
  
  attr_accessible :username, :email, :password
  attr_accessor :password
  
  before_save :generate_password
  
  def self.authenticate(email, password)
    user = Admin.find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.salt_hash)
      user.password_reset_hash = nil unless user.password_reset_hash.nil?
      user
    else
      nil
    end
  end
  
  def save_ip(ip)
    self.last_login_ip = ip
    self.save
  end
  
  def save_login_date
    self.last_login_date = Time.now
    self.save
  end
  
  def to_label
    username
  end
  
  def reset_password
    pass = (1..5).map{97.+(rand(25)).chr}.join
    self.password_reset_hash = BCrypt::Engine.hash_secret(pass, self.salt_hash)
    self.save
    pass
  end
  
  def reset_password_do
    self.password_hash = self.password_reset_hash
    self.save
  end
  
  private
  
  def generate_password
    if password.present?
      self.salt_hash = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, salt_hash)
    end
  end

end