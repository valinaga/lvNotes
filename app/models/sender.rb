class Sender < ActiveRecord::Base
	has_many :letters, :order => 'sent DESC'
  has_one :recipient
  has_one :mapping, :dependent => :destroy

	before_create :gen_mapping
	
	validates :email, :presence => true, :uniqueness => {:scope => :provider}, :email_format => true, :on => :update
  
  STATUS = %w(NEW NO_MAIL ACTIVE)
  validates_inclusion_of :status, :in => STATUS

  attr_accessor :current_recipient
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
        user.status = "NO_MAIL" unless user.email
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
    return if status == 'ACTIVE'
    self.status = 'ACTIVE'
    self.save
  end
  
  def new?
    return status=='NEW'
  end

  def no_email?
    return status=='NO_MAIL'
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
  
  def appelation
    "My dear "  
  end
  
  def signature
    "\nFrom all my heart,\n\n#{first_name.titleize}"
  end
    
  def no_recipient?
    self.recipient.nil?
  end
  
  def email?
    !self.email.nil? && !self.email.empty?
  end

private
  def gen_mapping
    self.create_mapping(:email => email, :fake_mail => fake_email)
  end
  

end
