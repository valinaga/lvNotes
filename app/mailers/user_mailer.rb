class UserMailer < ActionMailer::Base
#  default :from => "from@example.com"
  
  def welcome_email(letter)
    @sender = letter.sender
    @recipient = letter.recipient
    @msg = letter.message
    @url = "#{APP_URL}/home"
    mail( :from => "#{@sender.name} <#{@sender.fake_email}>",
          :to => "#{@sender.name} <#{@sender.email}>",
          :subject => "Welcome to LoveCards")
  end

  def send_email(letter)
  end
end
