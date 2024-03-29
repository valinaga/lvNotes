class Letter < ActiveRecord::Base
  belongs_to :sender
  belongs_to :recipient
  belongs_to :message

  before_create :gen_hashed
    
  STATUS = %w(NEW WAIT SENT READY PEND)
  validates_inclusion_of :status, :in => STATUS
  
  def ready
    return unless status == 'NEW'
    self.update_attributes(
      :status => 'WAIT',
      :sent => Time.now()
    )
  end
  
  def delivered
    self.update_attributes(
      :status => 'SENT',
      :sent => Time.now(),
      :next_date => gen_next_date)
    create_next_letter
  end
  
  def pending?
    status == 'PEND'
  end
  
  class << self
    def waiting
      where(:status => 'READY')
    end
    
    def since(time)
      where("sent < ?", time)
    end

    def next_for_delivery
      letter = Letter.waiting.since(40.days.from_now).first
      letter.update_attributes(:status => 'PEND') if letter
      letter
    end
    
    def pending
      where(:status => 'PEND').first
    end
    
    def recent(message = nil)
      letter = where(:status => 'NEW').first
      letter.update_attributes(:message => message) if letter && message
      letter
    end
  end  
  
  def label
    'Letter ID: ' + id.to_s
  end
  
  private
  
    def gen_status
      self.status = 'NEW'
    end
    
    def gen_hashed
      self.hashed = Base64.encode64(Time.now.hash.to_s+sender.hash.to_s)[0..-3]
    end    
    
    def gen_next_date
      #TODO to be from recipient.relation.delay
      n = sent + 1.hours + 47.minutes
      n -= 8.hours if n.hour() >= 17
      n + 17.days
    end
    
    def create_next_letter
      Letter.create(
        :sender => sender, 
        :recipient => recipient, 
        :sent => next_date, 
        :status => 'READY')
    end
  
end
