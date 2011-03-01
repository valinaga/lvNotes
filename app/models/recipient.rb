class Recipient < ActiveRecord::Base
	belongs_to :sender
	has_many :letters

  validates :first_name, :presence => true
  validates :last_name, :presence => true
	validates_format_of :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix
	
	def name
	  "#{first_name} #{last_name}"
	end
end
