class LettersController < ApplicationController
  before_filter :admin?
  active_scaffold :letter do |conf|
    conf.label = 'Sent messages'
    conf.actions = [:list, :search, :show] #:nested, :subform
    conf.columns = [:sender, :recipient, :message, :sent, :next_date, :status]
  end
end
