Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'ECY3RkpRtk7sNIa9OtELQ', 'X9oIRrQ9GSfQxKre7MmOM8gpoEx8dDOfZkX5paAQ'
  provider :facebook, '627711beba2da431d2266bfe40c41618', 'e042af88df1ec657121d3609e353740a', {:client_options => {:ssl => {:ca_file => 'cert/ca-bundle.crt'}}}
end

