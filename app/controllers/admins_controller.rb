class AdminsController < ApplicationController
  active_scaffold :admin do |conf|
    config.label = 'Admin Users'
    config.columns = [:username, :password, :email, :status]
  end
  
  def dashboard
    @total_active_admins = Admin.count(:conditions => "status = 'ACTIVE'")
    @total_active_senders = Sender.count(:conditions => "status = 'ACTIVE'")
    @total_sent_messages = Letter.count(:conditions => "status = 'SENT'")
    @total_pending_messages = Letter.count(:conditions => "status = 'READY'")
  end
  
  def login
    user = Admin.authenticate(params[:username], params[:password])
    if user
      user.session_hash = session[:admin]
    end
  end
end 