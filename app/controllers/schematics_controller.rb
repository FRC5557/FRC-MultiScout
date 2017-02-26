class SchematicsController < ApplicationController
  def update
    if user_signed_in?
      if ScoutSchema.exists?(name: params[:schema])
        team = Team.find(params[:team].to_i)
        schema = ScoutSchema.where(name: params[:schema]).first
        if team.nil?
          redirect_to root_path, alert: I18n.t('teams.not_exist')
        else
          if (current_user.is_team_manager && current_user.team_registration.team.id == params[:team].to_i) || current_user.is_administrator
            if team.update(scout_schema_id: schema.id)
              redirect_to edit_team_path(team.number), flash: {success: I18n.t('teams.schema_success')}
            else
              redirect_to edit_team_path(team.number), flash: {success: I18n.t('teams.not_saved')}
            end
          else
            redirect_to root_path, alert: I18n.t('teams.permissions')
          end
        end
      else
        redirect_to root_path, alert: I18n.t('teams.schema_not_exist')
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end
end
