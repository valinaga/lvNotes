class SendersController < ApplicationController
	active_scaffold :sender do |conf|
	end
  
  def signin
    @sender = Sender.new
    @recipient = @sender.recipients.build
  end
  
  def save
    @sender = Sender.new(params[:sender])
    if @sender.save
      session[:sender] = @sender
      redirect_to home_path(:sender => @sender)
    else
      render('signin')
    end
  end

  def home
    @sender = session[:sender] || Sender.find(14)
    session[:sender]=@sender
    @recipients = @sender.recipients(true)
    @letters = @sender.letters
    @messages = @sender.three_messages
  end
  
  def deliver
    @message = Message.find(params[:message])
    @sender = session[:sender]
    @let = @sender.letters.new(:recipient => @sender.recipients.first, :message => @message )
    @let.sent = Time.now()
    if @let.save
      UserMailer.welcome_email(@let).deliver
      redirect_to home_path
    else 
      render home_path
    end
  end
end
