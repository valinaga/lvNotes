class UserMailer < ActionMailer::Base
  default_url_options[:host] = ENV["RAILS_HOST"]
  layout 'welcome', :except => ['send_email', 'panic_email']
  
  def welcome_email(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @msg = letter.message
    # @url = activate_url(:h => letter.hashed)

    @uns = unsubscribe_url(:h => letter.hashed)
    @email = @sender.email
    I18n.locale = @sender.lang
    mail( :from => "#{t('yservice')} <no-reply@yourlove.ly>",
          :to => "#{@sender.name} <#{@sender.email}>",
          :subject => t('mwelcome'))
  end
  
  def activate_email(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @msg = letter.message
    @url = activate_url(:h => letter.hashed)
    I18n.locale = @sender.lang

    @uns = unsubscribe_url(:h => letter.hashed)
    @email = @sender.email
    mail( :from => "#{t('yservice')} <no-reply@yourlove.ly>",
          :to => "#{@sender.name} <#{@sender.email}>",
          :subject => t('mwelcome'))
  end
  
  def send_notification(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @messages = @sender.random_messages
    @url = deliver_url(:h => letter.hashed)
    I18n.locale = @sender.lang

    @uns = unsubscribe_url(:h => letter.hashed)
    @email = @sender.email
    mail( :from => "#{t('yservice')} <no-reply@yourlove.ly>",
          :to => "#{@sender.name} <#{@sender.email}>",
          :subject => t('mreminder'))
  end
  
  def send_email(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @msg = letter.message
    I18n.locale = @sender.lang
    mail( :from => "#{@sender.name} <#{@sender.fake_email}>",
          :to => "#{@recipient.name} <#{@recipient.email}>",
          :bcc => [@sender.features.exists?('bcc') ? @sender.email : ''],
          :subject => t('myourlovely'))
  end
  
  def panic_email(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @msg = letter.message
    I18n.locale = @sender.lang
    mail( :from => "#{@sender.name} <#{@sender.fake_email}>",
          :to => "#{@recipient.name} <#{@recipient.email}>",
          :bcc => @sender.features.exists?('bcc') ? @sender.email : '',
          :subject => t('msorry'))
  end
  
  def admin_reset_password(user, pass)
    @username = user.username
    @pass = pass
    @url = "#{admin_reset_do_url}?m=#{user.email}&h=#{user.password_reset_hash}"
    #@url = admin_reset_do_url(:m => user.email, :h => user.password_reset_hash)
    mail( :from => "yourLove.ly service <no-reply@yourlove.ly>",
          :to => "#{@username} <#{user.email}>",
          :subject => "password reset")
  end
end
