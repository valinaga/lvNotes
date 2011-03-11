#!/usr/bin/env ruby

# run with
#
# RAILS_ENV=development lib/daemons/mailer_ctl start
#
# You might want to change this
# ENV["RAILS_ENV"] ||= "production"
ENV["RAILS_ENV"] ||= "development"

require File.dirname(__FILE__) + "/../../config/application"
Rails.application.require_environment!

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  letter = Letter.next_for_delivery
  if letter
    UserMailer.send_notification(letter).deliver
  else
    sleep 10
  end
end