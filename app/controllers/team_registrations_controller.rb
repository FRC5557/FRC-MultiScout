class TeamRegistrationsController < ApplicationController
  def create
    if user_signed_in?
      number = params[:team]
      team = Team.where(number: number).first
      if team.nil?
        redirect_to edit_user_registration_path, alert: I18n.t('teams.not_found', number: number)
      else
        if current_user.team_registration.nil?
          if TeamRegistration.create(team_id: team.id, user_id: current_user.id)
            redirect_to edit_user_registration_path, flash: {success: I18n.t('teams.join_request', number: number)}
          else
            redirect_to edit_user_registration_path, flash: {error: I18n.t('teams.not_saved')}
          end
        else
          redirect_to edit_user_registration_path, alert: I18n.t('teams.additional')
        end
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def update
    if user_signed_in?
      number = params[:team]
      team = Team.where(number: number).first
      if team.nil?
        redirect_to edit_user_registration_path, alert: I18n.t('teams.not_found', number: number)
      else
        if current_user.team_registration.nil?
          if TeamRegistration.create(team_id: team.id, user_id: current_user.id)
            redirect_to edit_user_registration_path, flash: {success: I18n.t('teams.join_request', number: number)}
          else
            redirect_to edit_user_registration_path, flash: {error: I18n.t('teams.not_saved')}
          end
        else
          if current_user.team_registration.update(team_id: team.id, denied: false, confirmed_at: nil)
            redirect_to edit_user_registration_path, flash: {success: I18n.t('teams.join_request', number: number)}
          else
            redirect_to edit_user_registration_path, flash: {error: I18n.t('teams.not_saved')}
          end
        end
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def destroy
    if user_signed_in?
      if current_user.team_registration.nil?
        redirect_to edit_user_registration_path, alert: I18n.t('teams.not_exist')
      else
        if current_user.team_registration.destroy && current_user.update(is_team_manager: false)
          redirect_to edit_user_registration_path, flash: {success: I18n.t('teams.request_cancel')}
        else
          redirect_to edit_user_registration_path, flash: {error: I18n.t('teams.not_saved')}
        end
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def confirm
    if user_signed_in?
      if TeamRegistration.exists?(params[:id])
        if (current_user.is_team_manager && current_user.team_registration.team.id == TeamRegistration.find(params[:id]).team.id) || current_user.is_administrator
          if TeamRegistration.find(params[:id]).update(confirmed_at: Time.current)
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {success: I18n.t('teams.member_confirm')}
          else
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {error: I18n.t('teams.not_saved')}
          end
        else
          redirect_to root_path, alert: I18n.t('teams.permissions')
        end
      else
        redirect_to root_path, alert: I18n.t('teams.reg_not_exist')
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def deny
    if user_signed_in?
      if TeamRegistration.exists?(params[:id])
        if (current_user.is_team_manager && current_user.team_registration.team.id == TeamRegistration.find(params[:id]).team.id) || current_user.is_administrator
          if TeamRegistration.find(params[:id]).update(denied: true)
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {success: I18n.t('teams.member_deny')}
          else
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {error: I18n.t('teams.not_saved')}
          end
        else
          redirect_to root_path, alert: I18n.t('teams.permissions')
        end
      else
        redirect_to root_path, alert: I18n.t('teams.reg_not_exist')
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def remove
    if user_signed_in?
      if TeamRegistration.exists?(params[:id])
        if (current_user.is_team_manager && current_user.team_registration.team.id == TeamRegistration.find(params[:id]).team.id) || current_user.is_administrator
          reg = TeamRegistration.find(params[:id])
          if reg.update(denied: true) && reg.user.update(is_team_manager: false)
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {success: I18n.t('teams.member_remove')}
          else
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {error: I18n.t('teams.not_saved')}
          end
        else
          redirect_to root_path, alert: I18n.t('teams.permissions')
        end
      else
        redirect_to root_path, alert: I18n.t('teams.reg_not_exist')
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def promote
    if user_signed_in?
      if TeamRegistration.exists?(params[:id])
        if (current_user.is_team_manager && current_user.team_registration.team.id == TeamRegistration.find(params[:id]).team.id) || current_user.is_administrator
          reg = TeamRegistration.find(params[:id])
          if reg.user.update(is_team_manager: true)
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {success: I18n.t('teams.member_promote')}
          else
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {error: I18n.t('teams.not_saved')}
          end
        else
          redirect_to root_path, alert: I18n.t('teams.permissions')
        end
      else
        redirect_to root_path, alert: I18n.t('teams.reg_not_exist')
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def demote
    if user_signed_in?
      if TeamRegistration.exists?(params[:id])
        if (current_user.is_team_manager && current_user.team_registration.team.id == TeamRegistration.find(params[:id]).team.id) || current_user.is_administrator
          reg = TeamRegistration.find(params[:id])
          if reg.user.update(is_team_manager: false)
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {success: I18n.t('teams.member_demote')}
          else
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {error: I18n.t('teams.not_saved')}
          end
        else
          redirect_to root_path, alert: I18n.t('teams.permissions')
        end
      else
        redirect_to root_path, alert: I18n.t('teams.reg_not_exist')
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def check_in
    if user_signed_in?
      if TeamRegistration.exists?(params[:id])
        if (current_user.is_team_manager && current_user.team_registration.team.id == TeamRegistration.find(params[:id]).team.id) || current_user.is_administrator
          reg = TeamRegistration.find(params[:id])
          if reg.user.update(is_checked_in: true)
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {success: I18n.t('teams.member_check_in')}
          else
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {error: I18n.t('teams.not_saved')}
          end
        else
          redirect_to root_path, alert: I18n.t('teams.permissions')
        end
      else
        redirect_to root_path, alert: I18n.t('teams.reg_not_exist')
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def check_out
    if user_signed_in?
      if TeamRegistration.exists?(params[:id])
        if (current_user.is_team_manager && current_user.team_registration.team.id == TeamRegistration.find(params[:id]).team.id) || current_user.is_administrator
          reg = TeamRegistration.find(params[:id])
          if reg.user.update(is_checked_in: false)
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {success: I18n.t('teams.member_check_out')}
          else
            redirect_to edit_team_path(current_user.team_registration.team.number), flash: {error: I18n.t('teams.not_saved')}
          end
        else
          redirect_to root_path, alert: I18n.t('teams.permissions')
        end
      else
        redirect_to root_path, alert: I18n.t('teams.reg_not_exist')
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end
end
