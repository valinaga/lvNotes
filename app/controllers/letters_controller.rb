class LettersController < ApplicationController
  before_filter :admin?
end
