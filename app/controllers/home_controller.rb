class HomeController < ApplicationController
  skip_before_filter :require_signin, :only => :index

  def index
    if user_signed_in?
      I18n.locale = session[:lang] = current_user.lang      
      if !current_user.email?
        redirect_to new_mail_url
      elsif current_user.no_recipient?
        redirect_to new_recipient_url
      elsif current_user.inactive?
        redirect_to signup_url
      end
    end
  end
  
end
