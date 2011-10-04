class SessionsController < ApplicationController
  skip_before_filter :require_signin, :only => [:create, :failure, :destroy]

  def create
    auth = request.env["omniauth.auth"]
    sender = Sender.where(:provider => auth['provider'], :uid => auth['uid']).first 
    if sender.nil?
      sender = Sender.create_with_omniauth(auth)
      current_invitation.dec
    end
    sender.update_attribute(:lang, session[:country]) if sender.lang.nil?
    cookies.permanent[:auth_token] = sender.auth_token
    session[:sender] = sender
    redirect_to root_url
  end

  def destroy
    session[:sender] = nil
    session[:country] = nil
    cookies.delete(:auth_token)
    # session[:invitation] = nil
    # cookies.delete(:invite_token)
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end
