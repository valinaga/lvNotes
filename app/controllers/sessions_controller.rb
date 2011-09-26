class SessionsController < ApplicationController
  skip_before_filter :require_signin, :only => [:create, :failure]

  def create
    auth = request.env["omniauth.auth"]
    sender = Sender.where(:provider => auth['provider'], 
                        :uid => auth['uid']).first || Sender.create_with_omniauth(auth)
    session[:user_id] = sender.id
    session[:sender] = sender
    if !sender.email?
      redirect_to new_mail_url
    elsif sender.no_recipient?
      redirect_to new_recipient_url
    elsif sender.inactive?
      redirect_to signup_url
    else
      redirect_to root_url
    end
  end

  def destroy
    session[:user_id] = nil
    session[:sender] = nil
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end
