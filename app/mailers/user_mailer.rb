class UserMailer < ActionMailer::Base
  default_url_options[:host] = ENV["RAILS_HOST"]
  
  def welcome_email(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @msg = letter.message
    @url = activate_url(:h => letter.hashed)
    mail( :from => "LoveCards <no-reply@experiment.ro>",
          :to => "#{@sender.name} <#{@sender.email}>",
          :subject => "Welcome to LoveCards")
  end
  
  def send_notification(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @messages = @sender.three_messages
    @url = deliver_url(:h => letter.hashed)
    mail( :from => "LoveCards <no-reply@experiment.ro>",
          :to => "#{@sender.name} <#{@sender.email}>",
          :subject => "LoveCards Reminder")
  end
  
  def send_email(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @msg = letter.message
    mail( :from => "#{@sender.name} <#{@sender.fake_email}>",
          :to => "#{@recipient.name} <#{@recipient.email}>",
          :subject => "... your lovely")
  end
end
