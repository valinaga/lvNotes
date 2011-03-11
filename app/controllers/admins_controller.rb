class AdminsController < ApplicationController
  active_scaffold :admin do |conf|
    config.label = 'Admin Users'
    config.columns = [:username, :password, :email, :status, :session_hash]
  end
end 