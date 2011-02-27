class Recipient < ActiveRecord::Base
	belongs_to :sender

	validates_format_of :first_name, :with => /^(?:\b\w+\b[\s\r\n]*){2,3}$/
	validates_format_of :last_name, :with => /^(?:\b\w+\b[\s\r\n]*){2,3}$/
	validates_format_of :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix
end
