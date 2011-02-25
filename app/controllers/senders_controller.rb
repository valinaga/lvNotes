class SendersController < ApplicationController
  def index
    @sender = Sender.new
    @recipient = @sender.recipients.build
  end
  
  def create
    @sender = Sender.new(params[:sender])
    @sender.save ? redirect_to(sign_path(@sender), :notice => 'Sender was successfully created.') : render('index')
  end

end
