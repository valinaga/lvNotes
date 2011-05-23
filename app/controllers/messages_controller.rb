class MessagesController < ApplicationController
  before_filter :admin?

end
