class HomeController < ApplicationController
  skip_before_filter :require_signin, :only => :index
end
