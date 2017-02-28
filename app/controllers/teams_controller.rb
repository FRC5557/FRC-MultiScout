class TeamsController < ApplicationController
  include ErrorUtil
  include HTTPUtil

  def new
    if user_signed_in?
      @team = Team.new
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def show
    @team = Team.where(number: params[:id]).first
    if @team.nil?
      error_not_found
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

  def check_in
    unless user_signed_in?
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def check_in_active
    if user_signed_in?
      current_user.update(is_checked_in: true)
      redirect_to check_in_path
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def check_in_inactive
    if user_signed_in?
      current_user.update(is_checked_in: false)
      redirect_to check_in_path
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def import_pit_data
    if user_signed_in?
      if current_user.is_team_manager && !current_user.team_registration.nil?
        team = current_user.team_registration.team
        if team.event.nil?
          redirect_to edit_team_path(team.number), alert: I18n.t('teams.no_event')
        else
          url = 'https://www.thebluealliance.com/api/v2/event/' + team.event.key + '/teams'
          response = tba_request(url)
          data = JSON.parse(response.body)
          error = false

          data.each do |t|
            if !PitDatum.exists?(number: t["team_number"]) && team.number != t["team_number"]
              unless PitDatum.create(team_id: team.id, event_id: team.event.id, number: t["team_number"])
                error = true
              end
            end
          end

          if error
            redirect_to edit_team_path(team.number), alert: I18n.t('teams.pit_data_error')
          else
            redirect_to edit_team_path(team.number), flash: {success: I18n.t('teams.pit_success')}
          end
        end
      else
        redirect_to root_path, flash: {error: I18n.t('teams.permissions')}
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end
end
