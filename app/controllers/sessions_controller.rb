class SessionsController < ApplicationController
  skip_before_filter :require_signin, :only => [:create, :failure, :destroy, :locale]

  def create
    auth = request.env["omniauth.auth"]
    sender = Sender.where(:provider => auth['provider'], :uid => auth['uid']).first 
    if sender.nil?
      sender = Sender.create_with_omniauth(auth, session[:lang])
      current_invitation.dec
    end
    session[:token] = (auth['credentials']['token'] rescue nil)
    # if session[:token]
      # me = FbGraph::User.me(session[:token])
      # me.feed!(
        # :message => 'Updating via yourLove.ly',
        # :name => 'yourLove.ly',
        # :link => 'http://yourlove.ly',
        # :description => 'A nice webapp for your happyness'
      # )      
    # end
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
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
  
  def locale
    I18n.locale = session[:lang] = params[:lang]
    redirect_to root_url, :notice => 'Language changed!'
  end
end
