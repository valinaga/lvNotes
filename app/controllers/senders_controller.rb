class SendersController < ApplicationController
  
  before_filter :auth, :only => 'home'
	
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
      render('signup', :anchor => "fail")
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
    session[:d] = nil
    @letter = Letter.where(:hashed => params[:h]).first
    @message = Message.find(params[:m])
    if @letter && @message
      @letter.message = @message
      if params[:d] && params[:d] == 'yes'
        session[:d] = true
      else
        UserMailer.send_email(@letter).deliver 
      end
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
    session[:sender] = nil
    if @sender = Sender.authenticate(params[:name], params[:password])
      session[:sender] = @sender
#      respond_to do |format|
#        format.html { redirect_to home_path, :notice => "Welcome back!" }
#        format.mobile { redirect_to home_path }
#      end
      redirect_to home_path
    else
      flash[:alert] = "Invalid user/password combination"
      render 'login_form'
    end      
  end

  def logout
    session[:sender] = session[:letter] = nil
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
  
  def unsubscribe
    redirect_to signup_path, :notice => "You have been unsubscribed"
  end

  def notify
    #call_rake :send_mailing
    @letter = session[:letter]
    UserMailer.welcome_email(@letter).deliver
    redirect_to home_path
  end

private
  def auth1
    @sender = session[:sender]
    redirect_to signup_path, :alert => "Please login or SignUp!" unless @sender && @sender.active?
  end
  
end
