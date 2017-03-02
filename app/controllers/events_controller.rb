class EventsController < ApplicationController
  def update
    if user_signed_in?
      if params[:event].nil? || params[:event].split('(')[1].nil? || params[:event].split('(')[1].split(')')[0].nil?
        redirect_to edit_team_path, alert: I18n.t('teams.event_not_exist')
      else
        key = params[:event].split('(')[1].split(')')[0]
        team = current_user.team_registration.team
        if Event.exists?(key: key)
          event = Event.where(key: key).first
          if current_user.is_team_manager
            if team.update(event_id: event.id)
              redirect_to edit_team_path(team.number), flash: {success: I18n.t('teams.event_success')}
            else
              redirect_to edit_team_path(team.number), flash: {success: I18n.t('teams.not_saved')}
            end
          else
          redirect_to root_path, alert: I18n.t('teams.permissions')
          end
        else
          redirect_to edit_team_path, alert: I18n.t('teams.event_not_exist')
        end
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end
end
