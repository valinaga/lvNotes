class Admin < ActiveRecord::Base
  validates :username, :email, :presence => true, :uniqueness => true
  validates :email, :email_format => true
  
  attr_accessible :username, :email, :password, :password_confirmation
  attr_accessor :password, :password_confirmation
  
  before_create :generate_password
  
  def authenticate(username, password)
    user = Admin.find_by_username(username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.salt_hash)
      user
    else
      nil
    end
  end
  
  def save_ip(ip) #request.remote_ip ar trebui sa mearga din cotroller
    self.last_login_ip = ip
    self.save
  end
  
  def save_login_date
    self.last_login_date = Time.now #pune doar data fara ora
    self.save
  end
  
  def save_session
    self.session_hash = session
  end
  
  private
  def generate_password
    if password.present?
      self.salt_hash = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, salt_hash)
    end
  end
end