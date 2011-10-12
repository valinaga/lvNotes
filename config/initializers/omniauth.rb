Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'
  
# development
  provider :facebook, '627711beba2da431d2266bfe40c41618','e042af88df1ec657121d3609e353740a', {:scope => 'publish_stream,offline_access,email',:client_options => {:ssl => {:ca_file => 'cert/ca-bundle.crt'}}}
  provider :twitter, 'ECY3RkpRtk7sNIa9OtELQ','X9oIRrQ9GSfQxKre7MmOM8gpoEx8dDOfZkX5paAQ'
  provider :linked_in, 'vpxxq9lfgeqj', 'VROhTv0A0FpV7wCl'
# production
  # provider :twitter, 'yABWbIRA0s0s1Jc81B8Dg', 'IuboXnkpR7HFXm4S60WBYCxQyvr41KWE0DNYFQmGU5s'
  # provider :facebook, 'be2ad4bb809aa5768ee82da32dad9d26', '4d86565c2e66cfb66d8abded500cc4f8', {:client_options => {:ssl => {:ca_file => 'cert/ca-bundle.crt'}}}
  # provider :linked_in, 'vpxxq9lfgeqj', 'VROhTv0A0FpV7wCl'
  
# dedicated openid
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'yahoo', :identifier => 'yahoo.com' 
  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'




  Twitter.configure do |config|
    config.consumer_key = 'yABWbIRA0s0s1Jc81B8Dg'
    config.consumer_secret = 'IuboXnkpR7HFXm4S60WBYCxQyvr41KWE0DNYFQmGU5s'
    
    config.oauth_token = '14906914-FZ7ILmOyFM4uYyTIx5egaRbl1cAuZZjq60qhZ16m7'
    config.oauth_token_secret = 'tahAIfMmiASnL1C6sW7C3po61i8SFAvuxx8zHxy1AO4'
  end

end

# http://www.communityguides.eu/articles/16