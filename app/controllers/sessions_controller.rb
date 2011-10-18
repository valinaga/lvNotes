class SessionsController < ApplicationController
  skip_before_filter :require_signin #, :only => [:new, :create, :failure, :destroy, :locale]
  
  def new
    redirect_to "/auth/#{params[:provider]}"
  end

  def create
    auth = request.env["omniauth.auth"]
    sender = Sender.where(:provider => auth['provider'], :uid => auth['uid']).first 
    if sender.nil?
      sender = Sender.create_with_omniauth(auth, session[:lang])
      current_invitation.dec
    end
    if auth['provider'] == 'twitter'
      Twitter.configure do |config|
        config.consumer_key = APP_CONFIG[:twitter][:consumer_key]
        config.consumer_secret = APP_CONFIG[:twitter][:consumer_secret]
        config.oauth_token = (auth['credentials']['token'] rescue nil)  
        config.oauth_token_secret = (auth['credentials']['secret'] rescue nil)
      end
    end
    session[:token] = (auth['credentials']['token'] rescue nil) 
    I18n.locale = session[:lang] = sender.lang      
    cookies.permanent[:auth_token] = sender.auth_token
    session[:sender] = sender
    redirect_to root_url
  end

  def destroy
    session[:sender] = nil
    cookies.delete(:auth_token)
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    render :text => params[:message]
    # redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
  
  def locale
    I18n.locale = session[:lang] = params[:lang]
    redirect_to root_url, :notice => 'Language changed!'
  end
end
