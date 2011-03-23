class MessagesController < ApplicationController
  before_filter :admin?
	active_scaffold :message do |conf|
   conf.label = 'Messages'
   conf.columns = [:content, :lang]
   conf.columns[:lang].label = 'Language'
   conf.columns[:lang].form_ui = :select
   conf.columns[:lang].options[:options] = ['en', 'ro']
	end

end
