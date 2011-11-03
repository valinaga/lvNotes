class InvitationsController < ApplicationController
  skip_before_filter :require_invite, :only => [:invite, :invited]
  skip_before_filter :require_signin, :only => [:invite, :invited]
  
  def invite
    I18n.locale = session[:lang]
    respond_to do |format|
      format.mobile
      format.html { render :layout => 'splash' }
    end
  end

  def invited
    @invitation = InvitationPool.find_by_name(params[:name])
    if @invitation
      cookies.permanent[:invite_token] = @invitation.invite_token
      session[:invitation] = @invitation
      redirect_to root_url
    else
      respond_to do |format|  
        format.mobile {render :action => 'invite'}
        format.html { render :action => 'invite', :layout => 'splash' }
      end
    end
  end
end