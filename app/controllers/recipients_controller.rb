class RecipientsController < ApplicationController
  before_filter :admin?
	active_scaffold :recipient do |conf|
   conf.label = 'Recipients' 
   conf.columns = [:first_name, :last_name, :email, :relation, :sender, :letters]
   conf.actions = [:show, :list, :search]
	end
end
