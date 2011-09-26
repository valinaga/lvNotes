class UserMailer < ActionMailer::Base
  default_url_options[:host] = ENV["RAILS_HOST"]
  layout 'welcome', :except => 'send_email'
  
  def welcome_email(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @msg = letter.message
    # @url = activate_url(:h => letter.hashed)

    @uns = unsubscribe_url(:h => letter.hashed)
    @email = @sender.email
    mail( :from => "yourlove.ly service <no-reply@yourlove.ly>",
          :to => "#{@sender.name} <#{@sender.email}>",
          :subject => "Welcome to yourlove.ly")
  end
  
  def activate_email(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @msg = letter.message
    @url = activate_url(:h => letter.hashed)

    @uns = unsubscribe_url(:h => letter.hashed)
    @email = @sender.email
    mail( :from => "yourlove.ly service <no-reply@yourlove.ly>",
          :to => "#{@sender.name} <#{@sender.email}>",
          :subject => "Welcome to yourlove.ly")
  end
  
  def send_notification(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @messages = @sender.three_messages
    @url = deliver_url(:h => letter.hashed)

    @uns = unsubscribe_url(:h => letter.hashed)
    @email = @sender.email
    mail( :from => "yourlove.ly service <no-reply@yourlove.ly>",
          :to => "#{@sender.name} <#{@sender.email}>",
          :subject => "yourlove.ly gentle reminder")
  end
  
  def send_email(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @msg = letter.message
    mail( :from => "#{@sender.name} <#{@sender.fake_email}>",
          :to => "#{@recipient.name} <#{@recipient.email}>",
          :subject => "... your lovely")
  end
  
  def admin_reset_password(user, pass)
    @username = user.username
    @pass = pass
    @url = "#{admin_reset_do_url}?m=#{user.email}&h=#{user.password_reset_hash}"
    #@url = admin_reset_do_url(:m => user.email, :h => user.password_reset_hash)
    mail( :from => "yourlove.ly service <no-reply@yourlove.ly>",
          :to => "#{@username} <#{user.email}>",
          :subject => "password reset")
    
  end
  
end
