class InvitationsController < ApplicationController
  skip_before_filter :require_invite, :only => [:invite, :invited]
  skip_before_filter :require_signin, :only => [:invite, :invited]

  def invite
  end

  def invited
    @invitation = InvitationPool.find_by_name(params[:name])
    if @invitation
      cookies.permanent[:invite_token] = @invitation.invite_token
      session[:invitation] = @invitation
      redirect_to root_url
    else
      render :action => 'invite'
    end
  end
end
