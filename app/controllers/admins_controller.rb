class AdminsController < ApplicationController
  before_filter :admin?, :except => [:login, :password_reset, :password_reset_do]
  
  active_scaffold :admin do |conf|
    conf.columns = [:username, :password, :password_confirmation, :email, :last_login_date, :status]
    conf.columns[:password].form_ui = [:password, :password_confirmation]
    conf.list.columns.exclude [:password, :password_confirmation]
    conf.show.columns.exclude [:password, :password_confirmation]
    conf.create.columns.exclude [:last_login_date]
    conf.update.columns.exclude [:last_login_date]
    conf.columns[:status].form_ui = :select
    conf.columns[:status].options[:options] = ["ACTIVE", "INACTIVE"]
  end
  
  def dashboard
    @total_active_admins = Admin.count(:conditions => "status = 'ACTIVE'")
    @total_active_senders = Sender.count(:conditions => "status = 'ACTIVE'")
    @total_sent_messages = Letter.count(:conditions => "status = 'SENT'")
    @total_pending_messages = Letter.count(:conditions => "status = 'READY'")
  end
  
  def login
    if request.post?
      user = Admin.authenticate(params[:email], params[:password])
      if user
        session[:admin_user_id] = user.id
        session[:admin_last_ip] = user.last_login_ip
        session[:admin_last_date] = user.last_login_date
        user.save_login_date
        user.save_ip(request.remote_ip)
        redirect_to admin_dashboard_url, :notice => 'Loged in'
      else
        flash[:notice] = 'wrong email or password'
      end
    elsif request.get? && session[:admin_user_id] != nil
      redirect_to admin_dashboard_url
    end
  end
  
  def password_reset
    if request.post?
      user = Admin.find_by_email(params[:email])
      if user
        pass = user.reset_password
        UserMailer.admin_reset_password(user, pass).deliver
        redirect_to signup_url, :notice => 'Check your e-mail address for further instructions'
      else
        redirect_to signup_url, :notice => 'Wrong user'
      end
    end
  end
  
  def password_reset_do
    if request.get?
      user = Admin.find_by_email_and_password_reset_hash(params[:m], params[:h])
      if user
        user.reset_password_do
        redirect_to admin_login_url, :notice => 'Your password has been reset. It is advised to change it after login'
      else
        redirect_to signup_url, :notice => 'Wrong params'
      end
    end
  end
  
  def logout
    reset_session
    redirect_to admin_dashboard_url, :notice => 'Loged out'
  end
  
  def manage_admins
    admin?
  end
end 