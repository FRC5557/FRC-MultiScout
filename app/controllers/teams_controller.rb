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

        @matches = @team.event.nil? ? [] : JSON.parse(tba_request('https://www.thebluealliance.com/api/v2/event/' + @team.event.key + '/matches').body)
      else
        redirect_to root_path, flash: {error: I18n.t('teams.permissions')}
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def check_in
    if user_signed_in?
      if current_user.team_registration.nil? || !current_user.team_registration.current_reg?
        redirect_to edit_user_registration_path, alert: I18n.t('teams.not_exist')
      else
        if current_user.team.event.nil?
          redirect_to root_path, alert: I18n.t('teams.check_in_event')
        else
          if current_user.is_checked_in
            if current_user.empty_event_pit_data.count < 6
              num_to_add = 6 - current_user.empty_event_pit_data.count
              pit_data = current_user.team_registration.team.event.pit_data.where('user_id IS NULL').limit(num_to_add)
              pit_data.each do |data|
                data.update(user_id: current_user.id)
              end
            end

            unless current_user.has_match_scout_assignment?
              match_scouts = current_user.team.match_scout_assignments
              match_scouts.each do |station|
                if station[1] == nil
                  match_scouts[station[0]] = current_user.id
                  break
                end
              end
              current_user.team.update(scout_assignments: match_scouts.to_s)
            end

            @empty = JSON.parse(tba_request('https://www.thebluealliance.com/api/v2/event/' + current_user.event.key + '/matches').body).empty?
            match_scout_list = current_user.event.empty_match_data.where('team_id=? AND station=?', current_user.team.id, current_user.match_scout_assignment)
            match_scout_order = match_scout_list.order(competition_stage: :asc, set_number: :asc, match_number: :asc)
            @user_match_scout_list = match_scout_order.page(params[:page].nil?? 1 : params[:page]).per(10)
          else
            pit_data = current_user.empty_event_pit_data
            pit_data.each do |data|
              data.update(user_id: nil)
            end

            match_scouts = current_user.team.match_scout_assignments
            match_scouts.each do |station|
              if station[1] == current_user.id
                match_scouts[station[0].to_param] = nil
              end
            end

            current_user.team.update(scout_assignments: match_scouts.to_s)
          end
        end
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def check_in_active
    if user_signed_in?
      if current_user.team_registration.team.nil?
        redirect_to edit_user_registration_path, alert: I18n.t('teams.not_exist')
      end
      current_user.update(is_checked_in: true)
      redirect_to check_in_path
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def check_in_inactive
    if user_signed_in?
      if current_user.team_registration.team.nil?
        redirect_to edit_user_registration_path, alert: I18n.t('teams.not_exist')
      end
      current_user.update(is_checked_in: false)
      redirect_to check_in_path
    else
      redirect_to new_user_session_path, alert: I18n.t('teams.sign_in')
    end
  end

  def import_pit_data
    if user_signed_in?
      if current_user.is_team_manager && !current_user.team_registration.nil? && current_user.team_registration.current_reg?
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

  def import_match_data
    if user_signed_in?
      if current_user.is_team_manager && !current_user.team_registration.nil? && current_user.team_registration.current_reg?
        team = current_user.team_registration.team
        if team.event.nil?
          redirect_to edit_team_path(team.number), alert: I18n.t('teams.no_event')
        else
          url = 'https://www.thebluealliance.com/api/v2/event/' + team.event.key + '/matches'
          response = tba_request(url)
          data = JSON.parse(response.body)
          error = false

          data.each do |t|
            comp_stage = case t["comp_level"]
            when 'qm'
              1
            when 'ef'
              2
            when 'qf'
              3
            when 'sf'
              4
            when 'f'
              5
            end
            unless MatchDatum.exists?(match_number: t["match_number"], set_number: t["set_number"], competition_stage: comp_stage)
              t["alliances"].each do |alliance|
                count = 1
                alliance[1]["teams"].each do |team|
                  number = team.gsub('frc', '')
                  station = alliance[0] + '_' + count.to_s
                  unless MatchDatum.create(team_id: current_user.team.id, event_id: current_user.event.id, competition_stage: comp_stage, set_number: t["set_number"], match_number: t["match_number"], team_number: number, station: station, match_time: t["time_string"])
                    error = true
                  end
                  count += 1
                end
              end
            end
          end

          if error
            redirect_to edit_team_path(team.number), alert: I18n.t('teams.match_data_error')
          else
            redirect_to edit_team_path(team.number), flash: {success: I18n.t('teams.match_success')}
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
