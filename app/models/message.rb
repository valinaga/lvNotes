class Message < ActiveRecord::Base
	has_many :letters

	scope :ro, where(:lang => 'ro')
  scope :en, where(:lang => 'en')

  scope :except, lambda {|exception_list| where("id not in (?)", exception_list) }
end
