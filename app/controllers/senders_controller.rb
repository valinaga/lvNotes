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
      @sender.save!
      redirect_to(recipient_path) if @sender.recipients.nil? 
      @messages = @sender.three_messages
      @sender.current_recipient = @sender.recipients.last
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
      @letter.wait
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
    begin
      @letter = Letter.where(:hashed => params[:h]).first
      @message = Message.find(params[:m])
      @letter.message = @message
      UserMailer.send_email(@letter).deliver
      @letter.delivered
      session[:letter] = @letter
      redirect_to delivered_path
    rescue
      redirect_to home_path 
    end
  end
  
  def delivered
    @letter = session[:letter]
    if @letter.nil?
      redirect_to signin_path 
    end
  end
  
  def home
    @sender = session[:sender]
    if @sender
      @recipients = @sender.recipients
      @letters = @sender.letters
    else
      redirect_to signin_path
    end
  end
  
  def login
    if request.post?
      if @sender = Sender.authenticate(params[:name], params[:password])
        session[:sender] = @sender
        redirect_to home_url
      else
        redirect_to login_url, :alert => "Invalid user/password combination"
      end      
    end
  end

  def logout
    # save_admin = session[:admin_id]
    reset_session
    # session[:admin_id] = save_admin 
    redirect_to signin_path
  end

  

  def notify
    call_rake :send_mailing
    #@letter = Letter.next_for_delivery
    #UserMailer.send_notification(@letter).deliver
    #session[:sender] = @letter.sender
    redirect_to home_path
  end

end
