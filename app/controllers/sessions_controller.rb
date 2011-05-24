class SessionsController < ApplicationController
  def new
    redirect_to "/auth/#{params[:provider]}"
  end

  def create
    auth = request.env["omniauth.auth"]
    user = Sender.where(:provider => auth['provider'], 
                      :uid => auth['uid']).first || Sender.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, :notice => 'Signed in!'
#    if !user.email
#      redirect_to edit_user_path(user), :alert => 'Please enter your email address.'
#    else
#    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end
