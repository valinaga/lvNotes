class RecipientsController < ApplicationController
  
  def index
    @recipient = current_user.recipient
    render :action => 'edit'
  end

  def new
    @recipient = current_user.build_recipient
  end

  def edit
    @recipient = current_user.recipient
  end

  # POST /recipients
  # POST /recipients.xml
  def create
    @recipient = current_user.build_recipient(params[:recipient])
    if @recipient.save
      redirect_to signup_url 
    else
      render :action => "new" 
    end
  end

  # PUT /recipients/1
  # PUT /recipients/1.xml
  def update
    @recipient = current_user.recipient
    if @recipient.update_attributes(params[:recipient])
      redirect_to root_url(:anchor => "settings") 
    else
      render :action => "edit" 
    end
  end
  
  def show
    redirect_to root_url(:anchor => "settings") 
  end

  # DELETE /recipients/1
  # DELETE /recipients/1.xml
  def destroy
    @recipient = current_user.recipient.find(params[:id])
    @recipient.destroy
    redirect_to root_url
  end
end
