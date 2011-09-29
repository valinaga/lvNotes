class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :prepare_for_mobile
  before_filter :require_signin
  before_filter :geoip

  def call_rake(task, options = {})
    options[:rails_env] ||= Rails.env
    args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
    system "start rake #{task} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/rake.log"
  end

  def require_signin
    redirect_to root_path, :alert => "Please SignUp!" unless user_signed_in?
  end

private
  def require_signin
    redirect_to root_path, :alert => "Please SignUp!" unless user_signed_in?
  end
  helper_method :require_signin
  
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
  helper_method :current_admin_user

  def geoip
    # return if session[:country]
    @geoip ||= GeoIP.new("#{RAILS_ROOT}/db/GeoIP.dat")    
    remote_ip = request.remote_ip if remote_ip != "127.0.0.1" 
    #todo: check for other local addresses or set default value
    location_location = @geoip.country(remote_ip)
    raise location_location.to_json
    # session[:country] = location_location[2] if location_location
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


  # OmniAuth
  
  def current_user
    begin
      @current_user ||= Sender.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
  helper_method :current_user

  def user_signed_in?
    return true if current_user
  end
  helper_method :user_signed_in?
  
  def correct_user?
    @user = Sender.find(params[:id])
    unless current_user == @user
      redirect_to root_url, :alert => "Access denied."
    end
  end
  helper_method :correct_user?

end
