class Message < ActiveRecord::Base
	has_many :letters
  
	# scope :ro, where(:lang => 'ro')
  # scope :en, where(:lang => 'en')
  # scope :lang, lambda {|lang| where :lang => (lang.nil? ? "en" : lang) }
  # scope :exclude, lambda {|exclude_list| where("id not in (?)", exclude_list) }
  # scope :special, lambda {|spec| where :special => spec}
  class << self
    def ro
      where(:lang => 'ro')
    end
    
    def en
      where(:lang => 'en')
    end

    def lang(lang)
      where(:lang => (lang.nil? ? "en" : lang))
    end
    
    def exclude(exclude_list)
      where("id not in (?)", exclude_list)
    end
    
    def special(special)
      where(:special => special)
    end
  end
  
  def to_label
    'Message ID: ' + id.to_s
  end
end
