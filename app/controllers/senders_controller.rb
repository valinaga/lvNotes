class SendersController < ApplicationController
	active_scaffold :sender do |conf|
	end
  
  def signin
    session[:sender] = nil
    @sender = Sender.new
    @recipient = @sender.recipients.build
  end
  
  def register
    begin
      @sender = Sender.new(params[:sender])
      @messages = @sender.three_messages
      @sender.save
      session[:sender] = @sender
      render('messages')
    rescue
      render('signin')
    end
  end

  def subscribe
    begin
      @message = Message.find(params[:m])
      @sender = session[:sender]
      @letter = @sender.letters.new(:recipient => @sender.recipients.first, :message => @message )
      @letter.save
      UserMailer.welcome_email(@letter).deliver
      session[:letter] = @letter
      redirect_to pending_path
    rescue
      redirect_to signin_path        
    end
  end
  
  # called from welcome letter
  def activate
    begin
      @letter = Letter.where(:hashed => params[:h]).first
      @letter.sender.activate
      @letter.ready
      UserMailer.send_email(@letter).deliver
      @letter.delivered
      session[:letter] = @letter
      redirect_to activated_path
    rescue
      redirect_to signin_path        
    end
  end
  
  # called from notification letter from daemon
  def deliver
#    begin
      @letter = Letter.where(:hashed => params[:h]).pending.first
      @message = Message.find(params[:m])
      @letter.message = @message
      UserMailer.send_email(@letter).deliver
      @letter.delivered
      session[:letter] = @letter
      redirect_to delivered_path
#    rescue
#      redirect_to home_path 
#    end
  end
  
  def delivered
    @letter = session[:letter]
    redirect_to signin_path if @letter.nil?
  end
  
  def notify
    @letter = Letter.next_for_delivery
    UserMailer.send_notification(@letter).deliver
    session[:sender] = @letter.sender
    redirect_to home_path
  end
  

  def home
    @sender = session[:sender] || Sender.find(14)
    session[:sender]=@sender
    @recipients = @sender.recipients(true)
    @letters = @sender.letters
    @messages = @sender.three_messages
  end

end
