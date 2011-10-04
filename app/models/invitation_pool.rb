class InvitationPool < ActiveRecord::Base
  belongs_to :sender
  
  def dec
    update_attribute(:total, self.total-1) unless self.total == 0    
  end
  
end
