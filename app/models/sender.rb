class Sender < ActiveRecord::Base
	has_many :letters, :order => 'sent DESC'
  has_one :recipient
  has_one :mapping, :dependent => :destroy
  has_one :invitation_pool

	before_create :init
	before_create {generate_token(:auth_token)}
	after_create :generate_invitations
	
	validates :email, :presence => true, :uniqueness => {:scope => :provider}, :email_format => true, :on => :update
  
  STATUS = %w(NEW NO_MAIL ACTIVE)
  validates_inclusion_of :status, :in => STATUS

  attr_accessor :current_recipient
  attr_accessible :provider, :uid, :first_name, :last_name, :email, :nickname, :signature, :lang

  def self.create_with_omniauth(auth, lang)
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
        user.lang = lang
      end
    # rescue Exception
      # raise Exception #, "cannot create user record" 
    # end
  end

  def random_messages(number = nil, special = nil)
    n = number || 3;
    if letters(true).empty?
      Message.lang(self.lang).special(special).limit(n).order('RAND()')
    else
      if self.letters.joins(:message).merge(Message.special(special)).empty?
        Message.exclude(self.letters.collect(&:message_id).compact).lang(self.lang).special(special).limit(n).order('RAND()')
      else
        Message.exclude(letters.joins(:message).merge(Message.special(special)).collect(&:message_id).compact).lang(self.lang).special(special).limit(n).order('RAND()')
      end
    end
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Sender.exists?(column => self[column])
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
    "#{(name.downcase+" "+provider[0,1]).gsub(/[\s]+/,'.')}@yourlove.ly"
  end
  
  def update_mapping
    mapping.update_attribute(:email, self.email)
  end
  
  def expand_sign
    "\n#{signature}, \n\n#{nickname.titleize}"
  end
    
  def no_recipient?
    self.recipient.nil?
  end
  
  def email?
    !self.email.nil? && !self.email.empty?
  end

private
  
  def init
    self.nickname = self.first_name
    self.create_mapping(:email => email, :fake_mail => fake_email)
    self.signature = I18n.t("my_heart")
  end
  
  def generate_invitations
    self.create_invitation_pool(:name => self.name.gsub(" ",""), :total => 15, :invite_token => SecureRandom.urlsafe_base64)
  end 

end
