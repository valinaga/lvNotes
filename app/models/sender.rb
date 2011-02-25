class Sender < ActiveRecord::Base
	has_many :recipients
	accepts_nested_attributes_for :recipients, :allow_destroy => true
 	accepts_nested_attributes_for :recipients, :reject_if => :all_blank
	
	validates_format_of :first_name, :with => /^(?:\b\w+\b[\s\r\n]*){2,3}$/, :message => "Prenume invalid! Completeaza corect Prenumele."
	validates_format_of :last_name, :with => /^(?:\b\w+\b[\s\r\n]*){2,3}$/, :message => "Nume invalid! Completeaza corect Numele."
	validates_format_of :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix, :message => "E-mail invalid!"
	
end
