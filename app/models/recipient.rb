class Recipient < ActiveRecord::Base
	belongs_to :sender
	has_many :letters, :dependent => :destroy

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true, :email_format => true
	
	def name
	  "#{first_name} #{last_name}"
	end

  def appelation
    I18n.t("my_dear")
  end
end
