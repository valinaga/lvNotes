class UserMailer < ActionMailer::Base
#  default :from => "from@example.com"
  default_url_options[:host] = "localhost:3000"
  
  def welcome_email(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @msg = letter.message
    @url = activate_url(:h => letter.hashed)
    mail( :from => "#{@sender.name} <#{@sender.fake_email}>",
          :to => "#{@sender.name} <#{@sender.email}>",
          :subject => "Welcome to LoveCards")
  end

  def send_email(letter)
  end
end
