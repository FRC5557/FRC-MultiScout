class Admin::ImportController < ApplicationController
  include HTTPUtil
  def import_events
    year = Time.current.strftime("%Y")
    url = "https://www.thebluealliance.com/api/v2/events/" + year
    response = request_with_headers(url, {'X-TBA-App-Id':'frc5557:scouting-system:a1'}, true)
    data = JSON.parse(response.body)
    error = false

    data.each do |event|
      unless Event.create(key: event["key"], name: event["name"], start_date: event["start_date"], end_date: event["end_date"], website: event["website"])
        error = true
      end
    end

    if error
      redirect_to admin_tba_imports_path, alert: I18n.t('admin.event_import_error')
    else
      redirect_to admin_tba_imports_path, flash: {success: I18n.t('admin.event_import_success')}
    end
  end

  def update_events
    year = Time.current.strftime("%Y")
    url = "https://www.thebluealliance.com/api/v2/events/" + year
    response = request_with_headers(url, {'X-TBA-App-Id':'frc5557:scouting-system:a1'}, true)
    data = JSON.parse(response.body)
    error = false
    count = 0

    data.each do |event|
      if Event.where(key: event["key"]).first.nil?
        unless Event.create(key: event["key"], name: event["name"], start_date: event["start_date"], end_date: event["end_date"], website: event["website"])
          count += 1
          error = true
        end
      end
    end

    if error
      redirect_to admin_tba_imports_path, alert: I18n.t('admin.event_import_error')
    else
      redirect_to admin_tba_imports_path, flash: {success: I18n.t('admin.event_update_success', plural: ActionController::Base.helpers.pluralize(count, 'event'))}
    end
  end

  def reset_events
    start_date = Time.current.beginning_of_year.strftime('%Y-%m-%d')
    end_date = Time.current.end_of_year.strftime('%Y-%m-%d')
    Event.where('start_date >= ? AND end_date <= ?', start_date, end_date).destroy_all

    year = Time.current.strftime("%Y")
    url = "https://www.thebluealliance.com/api/v2/events/" + year
    response = request_with_headers(url, {'X-TBA-App-Id':'frc5557:scouting-system:a1'}, true)
    data = JSON.parse(response.body)
    error = false

    data.each do |event|
      unless Event.create(key: event["key"], name: event["name"], start_date: event["start_date"], end_date: event["end_date"], website: event["website"])
        error = true
      end
    end

    if error
      redirect_to admin_tba_imports_path, alert: I18n.t('admin.event_import_error')
    else
      redirect_to admin_tba_imports_path, flash: {success: I18n.t('admin.event_reset_success')}
    end
  end

  def delete_events
    start_date = Time.current.beginning_of_year.strftime('%Y-%m-%d')
    end_date = Time.current.end_of_year.strftime('%Y-%m-%d')
    if Event.where('start_date >= ? AND end_date <= ?', start_date, end_date).destroy_all
      redirect_to admin_tba_imports_path, flash: {success: I18n.t('admin.event_delete_success')}
    else
      redirect_to admin_tba_imports_path, alert: I18n.t('admin.event_import_error')
    end
  end
end
