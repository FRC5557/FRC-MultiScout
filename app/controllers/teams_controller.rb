class TeamsController < ApplicationController
  def new
    if user_signed_in?
      @team = Team.new
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def edit
    if user_signed_in?
      @team = Team.where(number: params[:id]).first
      if !@team.nil? && ((params[:id].to_i == current_user.team_registration.team.number && current_user.is_team_manager && current_user.team_registration.current_reg?) || current_user.is_administrator)
        @page_confirmed = @team.confirmed_members.page(params[:pagec].nil?? 1 : params[:pagec]).per(10)
        @page_unconfirmed = @team.unconfirmed_members.page(params[:pageu].nil?? 1 : params[:pageu]).per(10)
      else
        redirect_to root_path, flash: {error: I18n.t('teams.permissions')}
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end
end
