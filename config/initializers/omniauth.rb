Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'yABWbIRA0s0s1Jc81B8Dg', 'IuboXnkpR7HFXm4S60WBYCxQyvr41KWE0DNYFQmGU5s'
  provider :facebook, 'be2ad4bb809aa5768ee82da32dad9d26', '4d86565c2e66cfb66d8abded500cc4f8', {:client_options => {:ssl => {:ca_file => 'cert/ca-bundle.crt'}}}
end

