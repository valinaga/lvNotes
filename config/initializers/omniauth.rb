Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'
  
  provider :facebook, APP_CONFIG[:facebook][:app_id], APP_CONFIG[:facebook][:app_secret], {:scope => 'publish_stream,offline_access,email',:client_options => {:ssl => {:ca_file => 'cert/ca-bundle.crt'}}}
  provider :twitter, APP_CONFIG[:twitter][:consumer_key], APP_CONFIG[:twitter][:consumer_secret]
  provider :linked_in, APP_CONFIG[:linked_in][:app_key], APP_CONFIG[:linked_in][:app_secret]
  
# dedicated openid
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'yahoo', :identifier => 'yahoo.com' 
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'



end

Twitter.configure do |config|
  config.consumer_key = APP_CONFIG[:twitter][:consumer_key]
  config.consumer_secret = APP_CONFIG[:twitter][:consumer_secret]
end


# http://www.communityguides.eu/articles/16