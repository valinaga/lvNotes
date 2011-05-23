class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :prepare_for_mobile
  helper_method :current_admin_user

  ActiveScaffold.set_defaults do |config| 
    config.ignore_columns.add [:created_at, :updated_at, :lock_version]
  end
  
  def call_rake(task, options = {})
    options[:rails_env] ||= Rails.env
    args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
    system "start rake #{task} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/rake.log"
  end
  
private
  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?
  
  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end
  
  def current_admin_user
    Admin.find_by_id(session[:admin_user_id]) if session[:admin_user_id]
  end

  def admin?
    if !current_admin_user
      redirect_to :signup
      false
    end
  end
  
  def seesion_update
    if session[:admin_user_id] && session[:last_seen] < 30.minutes.ago
        reset_session
      else
        session[:last_seen] = Time.now
      end
    end
end
