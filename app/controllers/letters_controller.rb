class LettersController < ApplicationController
  def show
    @letter = Letter.find(params[:id])
    I18n.locale = session[:lang] = current_user.lang if current_user
  end
end
