class Sender < ActiveRecord::Base
	has_many :letters, :order => 'sent DESC'
  has_many :recipients, :dependent => :destroy, :validate => true
  has_one :mapping, :dependent => :destroy

	attr_accessor :current_recipient
  accepts_nested_attributes_for :recipients, :allow_destroy => true
  
	#before_create :gen_password, :if => :no_provider?
	before_create :gen_mapping
	
	validates_associated :recipients
	
	# validates :first_name, :presence => true
	# validates :last_name, :presence => true
	validates :email, :presence => true, :uniqueness => {:scope => :provider}, :email_format => true, :on => :update
  
  STATUS = %w(NEW ACTIVE)
  validates_inclusion_of :status, :in => STATUS

  attr_accessible :provider, :uid, :first_name, :last_name, :email

  def self.create_with_omniauth(auth)
    # begin
      create! do |user|
        user.provider = auth['provider']
        user.uid = auth['uid']
        if auth['user_info']
          user.first_name, user.last_name = auth['user_info']['name'].split if auth['user_info']['name'] # Twitter, Google, Yahoo, GitHub
          user.email = auth['user_info']['email'] if auth['user_info']['email'] # Google, Yahoo, GitHub
        end
        if auth['extra'] && auth['extra']['user_hash']
          user.first_name, user.last_name  = auth['extra']['user_hash']['name'].split if auth['extra']['user_hash']['name'] # Facebook
          user.email = auth['extra']['user_hash']['email'] if auth['extra']['user_hash']['email'] # Facebook
        end
      end
    # rescue Exception
      # raise Exception #, "cannot create user record" 
    # end
  end

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
  
  def active?
    return status=='ACTIVE'
  end

  def inactive?
    return status!='ACTIVE'
  end

  def name
    "#{first_name} #{last_name}".titleize
  end
  
  def fake_email
    "#{name.gsub(/[\s]+/,'.')}@yourlove.ly"
  end
  
  def is_current(recipient)
    current_recipient == recipient
  end
  
  def appelation
    "My dear "  
  end
  
  def signature
    "\nFrom all my heart,\n\n#{first_name}"
  end
    
  # def self.authenticate(username, password)
    # sender = where(:email => username, :password => password).first
    # sender.current_recipient = sender.recipients.last unless sender.nil?
    # return sender
  # end
  
private
  
  # def gen_password
    # return unless password.nil?
    # nam = "#{first_name}#{last_name}"
    # self.password = nam[1,2]+nam[-3,3]
  # end 
  
  def gen_mapping
    self.create_mapping(:email => email, :fake_mail => fake_email)
  end
  
  def no_email?
    self.provider == 'twitter'
  end

  def no_provider?
    self.provider.nil?
  end
end
