class Event < ApplicationRecord
  has_and_belongs_to_many :teams
  has_many :pit_data

  def self.events_this_year
    start_date = Time.current.beginning_of_year.strftime('%Y-%m-%d')
    end_date = Time.current.end_of_year.strftime('%Y-%m-%d')

    Event.where('start_date >= ? AND end_date <= ?', start_date, end_date)
  end
end
