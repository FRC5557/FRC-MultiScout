class ScoutController < ApplicationController
  def index
  end

  def ping
    @response = "OK"
  end

  def pit_scout
    if user_signed_in?
      if current_user.team_registration.nil? || !current_user.team_registration.current_reg?
        redirect_back fallback_location: root_path, alert: I18n.t('scout.must_have_team')
      else
        if current_user.event.nil?
          redirect_back fallback_location: root_path, alert: I18n.t('scout.must_have_event')
        else
          if current_user.is_checked_in
            if current_user.empty_event_pit_data.count < 6
              num_to_add = 6 - current_user.empty_event_pit_data.count
              pit_data = current_user.team_registration.team.event.pit_data.where('user_id IS NULL').limit(num_to_add)
              pit_data.each do |data|
                data.update(user_id: current_user.id)
              end
            end
            if current_user.empty_event_pit_data.count > 0
              @pit_queue = current_user.empty_event_pit_data.select(:number, :data)
            else
              redirect_to check_in_path, alert: I18n.t('scout.no_more_pits')
            end
          else
            redirect_to check_in_path, alert: I18n.t('scout.must_check_in')
          end
        end
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('scout.sign_in')
    end
  end

  def submit_pit_scout
    if user_signed_in?
      if current_user.team_registration.nil? || !current_user.team_registration.current_reg?
        redirect_back fallback_location: root_path, alert: I18n.t('scout.must_have_team')
      else
        if current_user.event.nil?
          redirect_back fallback_location: root_path, alert: I18n.t('scout.must_have_event')
        else
          error = false
          numbers = ''
          params[:pit_data].each do |team_data|
            number = team_data.gsub('team', '').to_i
            numbers += number.to_s + ' '
            data = {}

            eval(current_user.team.scout_schema.pit_data).each do |section|
              section[1].each do |field|
                case field[1][0]
                when "select"
                  input_data = params[:pit_data][team_data.to_param][(field[0] + '_select').to_param]
                  if input_data.nil?
                    data[field[0].to_param] = nil
                  else
                    data[field[0].to_param] = field[1][1][input_data.to_i]
                    end
                when "checkbox"
                  input_data = params[:pit_data][team_data.to_param][(field[0] + '_check').to_param]
                  if input_data.nil?
                    data[field[0].to_param] = false
                  else
                    data[field[0].to_param] = true
                  end
                else
                  input_data = params[:pit_data][team_data.to_param][field[0].to_param]
                  data[field[0].to_param] = input_data
                end
              end
            end

            unless PitDatum.where(number: number, event_id: current_user.team.event.id, team_id: current_user.team.id, user_id: current_user.id).first.update(data: data.to_s)
              error = true
            end
          end

          if error
            redirect_to pit_scout_path, alert: I18n.t('scout.submit_error')
          else
            redirect_to pit_scout_path, flash: {success: I18n.t('scout.submit_success', numbers: numbers)}
          end
        end
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('scout.sign_in')
    end
  end

  def match_scout
    if user_signed_in?
      if current_user.team_registration.nil? || !current_user.team_registration.current_reg?
        redirect_back fallback_location: root_path, alert: I18n.t('scout.must_have_team')
      else
        if current_user.event.nil?
          redirect_back fallback_location: root_path, alert: I18n.t('scout.must_have_event')
        else
          if current_user.is_checked_in
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

            @match_queue = current_user.team.event.empty_match_data.where(station: current_user.match_scout_assignment, team_id: current_user.team.id).select(:competition_stage, :set_number, :match_number, :team_number).order(competition_stage: :asc, set_number: :asc, match_number: :asc)
          else
            redirect_to check_in_path, alert: I18n.t('scout.must_check_in')
          end
        end
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('scout.sign_in')
    end
  end

  def submit_match_scout
    if user_signed_in?
      if current_user.team_registration.nil? || !current_user.team_registration.current_reg?
        redirect_back fallback_location: root_path, alert: I18n.t('scout.must_have_team')
      else
        if current_user.event.nil?
          redirect_back fallback_location: root_path, alert: I18n.t('scout.must_have_event')
        else
          error = false
          mids = ''
          params[:match_data].each do |match_data|
            mid = match_data.gsub('match', '')
            stage = mid.split('_')[0]
            set = mid.split('_')[1]
            number = mid.split('_')[2]

            mids += mid + ' '
            data = {}

            eval(current_user.team.scout_schema.match_data).each do |section|
              next if section[0] == 'alliances'
              section[1].each do |field|
                case field[1][0]
                when "select"
                  input_data = params[:match_data][match_data.to_param][(field[0] + '_select').to_param]
                  if input_data.nil?
                    data[field[0].to_param] = nil
                  else
                    data[field[0].to_param] = field[1][1][input_data.to_i]
                  end
                when "checkbox"
                  input_data = params[:match_data][match_data.to_param][(field[0] + '_check').to_param]
                  if input_data.nil?
                    data[field[0].to_param] = false
                  else
                    data[field[0].to_param] = true
                  end
                when "counter"
                  input_data = params[:match_data][match_data.to_param][(field[0] + '_counter').to_param]
                  if input_data.nil?
                    data[field[0].to_param] = nil
                  else
                    data[field[0].to_param] = input_data
                  end
                when "location"
                  input_data_x = params[:match_data][match_data.to_param][(field[0] + '_location_x').to_param]
                  input_data_y = params[:match_data][match_data.to_param][(field[0] + '_location_y').to_param]
                  if input_data_x.nil?
                    data[(field[0] + '_x').to_param] = nil
                  else
                    data[(field[0] + '_x').to_param] = input_data_x
                  end
                  if input_data_y.nil?
                    data[(field[0] + '_y').to_param] = nil
                  else
                    data[(field[0] + '_y').to_param] = input_data_y
                  end
                else
                  input_data = params[:match_data][match_data.to_param][field[0].to_param]
                  data[field[0].to_param] = input_data
                end
              end
            end

            unless MatchDatum.where(station: current_user.match_scout_assignment, competition_stage: stage, set_number: set, match_number: number, event_id: current_user.team.event.id, team_id: current_user.team.id).first.update(data: data.to_s, user_id: current_user.id)
              error = true
            end
          end

          if error
            redirect_to match_scout_path, alert: I18n.t('scout.submit_error')
          else
            redirect_to match_scout_path, flash: {success: I18n.t('scout.submit_match_success', mids: mids)}
          end
        end
      end
    else
      redirect_to new_user_session_path, alert: I18n.t('scout.sign_in')
    end
  end
end
