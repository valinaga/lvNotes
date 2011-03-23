class SendersController < ApplicationController
  
  before_filter :auth, :only => 'home'
	
  active_scaffold :sender do |conf|
    conf.label = 'Senders'
  end
  
  def signup
    session[:sender] = nil
    @sender = Sender.new
    @recipient = @sender.recipients.build
  end
  
  def register
    @sender = Sender.new(params[:sender])
    if @sender.save
      @messages = @sender.three_messages
      @sender.current_recipient = @sender.recipients.last
      session[:sender] = @sender
      render('messages')
    else
      render('signup')
    end
  end

  def subscribe
    @message = Message.find(params[:m])
    @sender = session[:sender]
    if @sender && @message
      @letter = @sender.letters.new(:recipient => @sender.recipients.last, :message => @message )
      @letter.save!
      UserMailer.welcome_email(@letter).deliver
      session[:letter] = @letter
      redirect_to pending_path, :notice => "You're almost done!"
    else
      redirect_to signup_path, :alert => "Something went wrong!"
    end
  end
  
  # called from welcome letter
  def activate
    @letter = Letter.where(:hashed => params[:h]).first
    if @letter 
      @letter.sender.activate
      @letter.ready
      UserMailer.send_email(@letter).deliver
      @letter.delivered
      session[:letter] = @letter
      redirect_to activated_path, :notice=> "Your account was sucessfully activated!"
    else
      redirect_to signup_path, :alert => "Something went wrong!"
    end
  end
  
  # called from notification letter from daemon
  def deliver
    @letter = Letter.where(:hashed => params[:h]).first
    @message = Message.find(params[:m])
    if @letter && @message
      @letter.message = @message
      UserMailer.send_email(@letter).deliver
      @letter.delivered
      session[:letter] = @letter
      redirect_to delivered_path
    else
      redirect_to home_path, :alert => "Something went wrong!"
    end
  end
  
  def delivered
    @letter = session[:letter]
    if @letter.nil?
      redirect_to signup_path, :alert => "Something went wrong!" 
    end
  end
  
  def home
    @sender = session[:sender]
    redirect_to signup_path, :alert => "Something went wrong!" unless @sender
    @sender.letters(true)
  end
  
  def login
    if request.post?
      if @sender = Sender.authenticate(params[:name], params[:password])
        session[:sender] = @sender
        redirect_to home_url, :notice => "Welcome back #{@sender.name}!"
      else
        redirect_to login_url, :alert => "Invalid user/password combination"
      end      
    end
  end

  def logout
    # save_admin = session[:admin_id]
    reset_session
    # session[:admin_id] = save_admin 
    redirect_to signup_path, :notice => "You're logged out!"
  end
  
  def resend
    @sender = session[:sender]
    if @sender 
      @letter = @sender.letters.pending
      if @letter
        UserMailer.send_notification(@letter).deliver
        redirect_to home_path, :notice => "Resend succesfully!"
      else
        redirect_to home_path, :notice => "Nothing to resend"
      end
    else
      redirect_to signup_url, :alert => "Something went wrong!" 
    end    
  end

  

  def notify
    call_rake :send_mailing
    redirect_to home_path
  end

private
  def auth
    @sender = session[:sender]
    redirect_to signup_path, :alert => "Please login or SignUp!" unless @sender && @sender.active?
  end
end
