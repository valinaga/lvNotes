class Sender < ActiveRecord::Base
	has_many :recipients
	has_many :letters
	before_save :gen_password
	
	accepts_nested_attributes_for :recipients, :allow_destroy => true
 	accepts_nested_attributes_for :recipients, :reject_if => :all_blank
	
	validates :first_name, :presence => true
	validates :last_name, :presence => true
	validates_format_of :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix

  def three_messages
    # TODO get the lang from sender or recipient
    if letters(true).empty?
      Message.ro.limit(3).order('RAND()')
    else
      Message.except(letters.collect(&:message_id)).ro.limit(3).order('RAND()')
    end
  end
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def fake_email
    "#{email.gsub(/[@.]/,'_')}@experiment.ro"
  end
  
  private
    
    def gen_password
      nam = "#{first_name}#{last_name}"
      self.password = nam[1,2]+nam[-3,3]
    end

end
