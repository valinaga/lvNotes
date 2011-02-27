class SendersController < ApplicationController
	active_scaffold :sender do |conf|
	end
  
  def home
    @sender = Sender.new
    @recipient = @sender.recipients.build
  end
  
  def save
    @sender = Sender.new(params[:sender])
    @sender.save ? redirect_to(sign_path(@sender), :notice => 'Sender was successfully created.') : render('home')
  end

end
