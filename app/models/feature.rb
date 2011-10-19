class Feature < ActiveRecord::Base
  belongs_to :sender
  attr_accessible :name
  
  def self.exists?(param)
    !where(:name => param).first.nil?
  end
end
