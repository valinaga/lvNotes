class Letter < ActiveRecord::Base
  belongs_to :sender
  belongs_to :recipient
  belongs_to :message
end
