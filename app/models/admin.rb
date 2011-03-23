class Admin < ActiveRecord::Base
  
  validates :username, :email, :presence => true, :uniqueness => true
  validates :email, :email_format => true
  
  attr_accessible :username, :email, :password, :password_confirmation
  attr_accessor :password, :password_confirmation
  
  before_save :generate_password
  
  def self.authenticate(username, password)
    user = find_by_username(username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.salt_hash)
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
  
  def password_form_column(record, password)
    password_field_tag password, record.password_hash
  end
  
  def password_confirmation_form_column(record, password_hash)
    password_field_tag field_name, record.password_confirmation
  end
  
  def to_label
    username
  end
  
  private
  
  def generate_password
    if password.present?
      self.salt_hash = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, salt_hash)
    end
  end

end