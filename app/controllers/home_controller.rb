class HomeController < ApplicationController

  def savemail
    current_user.email=params[:sender][:email]
    current_user.save!
    respond_to do |format|
      format.html # show.html.erb
      format.mobile {render :index}
    end
  end
end
