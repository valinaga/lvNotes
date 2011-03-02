class SendersController < ApplicationController
	active_scaffold :sender do |conf|
	end
  
  def signin
    @sender = Sender.new
    @recipient = @sender.recipients.build
  end
  
  def save
    @sender = Sender.new(params[:sender])
    if @sender.save
      session[:sender] = @sender
      redirect_to home_path(:sender => @sender)
    else
      render('signin')
    end
  end

  def home
    @sender = session[:sender] || Sender.find(14)
    session[:sender]=@sender
    @recipients = @sender.recipients(true)
    @letters = @sender.letters
    @messages = @sender.three_messages
  end
  
  def subscribe
    begin
      @message = Message.find(params[:m])
      @sender = session[:sender]
      @letter = @sender.letters.new(:recipient => @sender.recipients.first, :message => @message )
      @letter.save
      UserMailer.welcome_email(@letter).deliver
      redirect_to home_path(:sender => @sender)
      #TODO de redirectat catre pagina de thankyou
    rescue
      render home_path(:sender => @sender)
    end
  end
  
  def activate
#    begin
      @letter = Letter.where(:hashed => params[:h]).first
      @letter.sender.activate
      @letter.ready
      redirect_to home_path(:sender => @letter.sender)
#    rescue
#      render home_path(:sender => @sender)
#    end
  end
  
  def deliver
    begin
      @sender = Sender.activate_by_hashed(params[:s])
      @let = @sender.letters.new(:recipient => @sender.recipients.first, :message => @message )
      UserMailer.welcome_email(@let).deliver
      @let.deliver
      redirect_to home_path(:sender => @sender)
    rescue
      redirect_to home_path(:sender => @sender)
    end
  end
end
