class SessionsController < ApplicationController
  # def new
    # redirect_to "/auth/#{params[:provider]}"
  # end

  def create
    auth = request.env["omniauth.auth"]
    user = Sender.where(:provider => auth['provider'], 
                        :uid => auth['uid']).first || Sender.create_with_omniauth(auth)
    session[:user_id] = user.id
    session[:sender] = user
    redirect_to root_url, :notice => 'Signed in!'
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
