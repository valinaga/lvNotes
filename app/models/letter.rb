class Letter < ActiveRecord::Base
  belongs_to :sender
  belongs_to :recipient
  belongs_to :message

  before_create :gen_hashed
  
  scope :pending, lambda { where(:status => 'READY') }
  scope :since, lambda {|time| where("sent < ?", time) }
  
  def ready
    return unless status == 'NEW'
    self.status = 'READY'
    self.sent = Time.now()
    self.save
  end
  
  def delivered
    self.status = 'SENT'
    self.sent = Time.now()
    self.next_date = gen_next_date
    self.save
    create_next_letter
  end
  
  def self.next_for_delivery
    Letter.pending.since(20.days.from_now).first
  end
  
#  private
  
    def gen_status
      self.status = 'NEW'
    end
    
    def gen_hashed
      self.hashed = Base64.urlsafe_encode64(self.hash.to_s)
    end    
    
    def gen_next_date
      #TODO to be from recipient.relation.delay
      n = sent + 1.hours + 47.minutes
      n -= 8.hours if n.hour() >= 17
      n + 17.days
    end
    
    def create_next_letter
      new_letter = Letter.new(
        :sender => sender, 
        :recipient => recipient, 
        :sent => next_date, 
        :status => 'READY')
      new_letter.save  
    end
  
end
