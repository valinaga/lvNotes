# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Lovecards::Application.initialize!

#APP_URL = "http://localhost:3000"
#APP_URL = "localhost:3000"

ENV['SSL_CERT_FILE'] = '/etc/ssl/certs/cacert.pem'
