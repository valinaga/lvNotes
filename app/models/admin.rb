class Admin < ActiveRecord::Base
  validates :username, :email, :presence => true, :uniqueness => true
  validates :password, :confirmation => true
  attr_accessor :password_confirmation
  attr_reader :password
  validates :email, :email_format => true
  
  #before_create generate_password
  
  private
  def generate_password
    nil
  end

end