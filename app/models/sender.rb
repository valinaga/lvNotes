class Sender < ActiveRecord::Base
	has_many :recipients, :dependent => :destroy, :validate => true
	has_many :letters
	attr_accessor :current_recipient

	after_initialize :gen_status
	before_create :gen_password
	
	accepts_nested_attributes_for :recipients, :allow_destroy => true
	
	validates_associated :recipients
	
	validates :first_name, :presence => true
	validates :last_name, :presence => true
	validates :email, :presence => true, :uniqueness => true, :email_format => true

  def three_messages
    # TODO get the lang from sender or recipient
    if letters(true).empty?
      Message.en.limit(3).order('RAND()')
    else
      Message.exclude(letters.collect(&:message_id).compact).en.limit(3).order('RAND()')
    end
  end
  
  def activate
    return unless status == 'NEW'
    self.status = 'ACTIVE'
    self.save
  end
  
  def inactive?
    return status!='ACTIVE'
  end

  def name
    "#{first_name} #{last_name}"
  end
  
  def fake_email
    "#{email.gsub(/[@.]/,'_')}@experiment.ro"
  end
  
  def self.authenticate(username, password)
    where(:email => username, :password => password).first
  end
  
  private
    
    def gen_password
      return unless password.nil?
      nam = "#{first_name}#{last_name}"
      self.password = nam[1,2]+nam[-3,3]
    end
    
    def gen_status
      return unless status.nil?
      self.status = 'NEW'
    end

end
