class Letter < ActiveRecord::Base
  belongs_to :sender
  belongs_to :recipient
  belongs_to :message

  after_initialize :gen_status
  before_create :gen_hashed
  
  def create_next_letter
    new_letter = Letter.new(:sender => sender, :recipient => recipient, :sent => next_date)  
  end
  
  def ready
    return unless status == 'NEW'
    self.status = 'READY'
    self.save
  end
  
  def deliver
    self.status = 'SENT'
    self.sent = Time.now()
    gen_next_date
    self.save
  end
  
  private
  
    def gen_status
      self.status = 'NEW'
    end
    
    def gen_hashed
      self.hashed = Base64.urlsafe_encode64(self.hash.to_s)
    end    
    
    def gen_next_date
      #TODO to be from recipient.relation.delay
      n = sent + 1.hours + 47.minutes
      n -= 8.hours if n.hour() > 17
      self.next_date = n + 17.days
    end
end
