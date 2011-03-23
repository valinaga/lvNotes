class Message < ActiveRecord::Base
	has_many :letters

	scope :ro, where(:lang => 'ro')
  scope :en, where(:lang => 'en')

  scope :exclude, lambda {|exclude_list| where("id not in (?)", exclude_list) }
  
  def to_label
    'Message ID: ' + id.to_s
  end
end
