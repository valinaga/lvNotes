# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Lovecards::Application

#ssh -L25:localhost:25 root@m.yourlove.ly