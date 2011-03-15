class AdminsController < ApplicationController
  active_scaffold :admin do |conf|
    config.label = 'Admin Users'
    config.columns = [:username, :password, :email, :status, :session_hash]
  end
  
  def dashboard
    @total_active_admins = Admin.count(:conditions => "status = 'ACTIVE'")
    @total_active_senders = Sender.count(:conditions => "status = 'ACTIVE'")
    @total_sent_messages = Letter.count(:conditions => "status = 'SENT'")
    @total_pending_messages = Letter.count(:conditions => "status = 'READY'")
  end
end 