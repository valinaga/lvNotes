class LettersController < ApplicationController
  def show
    @letter = Letter.find(params[:id])
  end
end
