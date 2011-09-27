class SendersController < ApplicationController
  skip_before_filter :require_signin, :only => [:activate,:deliver]
	
  def newmail
    @sender = current_user
  end

  def savemail
    begin
      @sender = current_user
      @sender.email=params[:sender][:email]
      @sender.save!
      redirect_to new_recipient_path
    rescue Exception
      render 'newmail' 
    end
  end
  
  def register
    @sender = current_user
    @messages = @sender.three_messages
    render('messages')
  end

  def subscribe
    @message = Message.find(params[:m])
    @sender = session[:sender]
    if @sender && @message
      @letter = @sender.letters.recent(@message) || @sender.letters.create(:recipient => @sender.recipient(true), :message => @message )
      session[:letter] = @letter
      if @sender.no_email?
        UserMailer.activate_email(@letter).deliver
        redirect_to pending_path, :notice => "You're almost done!"
      else
        UserMailer.welcome_email(@letter).deliver
        redirect_to activate_path
      end
    else
      redirect_to signup_path, :alert => "Something went wrong!"
    end
  end
  
  # called from welcome letter or subscribe
  def activate
    @letter = Letter.where(:hashed => params[:h]).first || session[:letter]
    if @letter 
      @letter.sender.activate
      @letter.ready
      UserMailer.send_email(@letter).deliver
      @letter.delivered
      session[:letter] = @letter
      if !user_signed_in? 
        session[:user_id] = @letter.sender.id
        session[:sender] = @letter.sender  
      end
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
      if !user_signed_in? 
        session[:user_id] = @letter.sender.id
        session[:sender] = @letter.sender  
      end
      redirect_to delivered_path
    else
      redirect_to root_path, :alert => "Something went wrong!"
    end
  end
  
  def delivered
    @letter = session[:letter]
    if @letter.nil?
      redirect_to signup_path, :alert => "Something went wrong!" 
    end
  end
  
  def update
    if current_user.update_attributes(params[:sender])
      redirect_to root_url 
    else
      render :action => "edit" 
    end    
  end
  
  def home
    @sender = session[:sender]
    redirect_to signup_path, :alert => "Something went wrong!" unless @sender
    @sender.letters(true)
  end
  
  # def login
    # session[:sender] = nil
    # if @sender = Sender.authenticate(params[:name], params[:password])
      # session[:sender] = @sender
# #      respond_to do |format|
# #        format.html { redirect_to home_path, :notice => "Welcome back!" }
# #        format.mobile { redirect_to home_path }
# #      end
      # redirect_to root_path
    # else
      # flash[:alert] = "Invalid user/password combination"
      # render 'login_form'
    # end      
  # end

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
        redirect_to root_path, :notice => "Resend succesfully!"
      else
        redirect_to root_path, :notice => "Nothing to resend"
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
    redirect_to root_path
  end

# private
  # def auth1
    # @sender = session[:sender]
    # redirect_to signup_path, :alert => "Please login or SignUp!" unless @sender && @sender.active?
  # end
  
end
