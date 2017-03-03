class PitDatum < ApplicationRecord
  require 'csv'
  belongs_to :team
  belongs_to :event
  belongs_to :user

  def self.to_csv(team, event)
    data = all.where(team_id: team, event_id: event).order(number: :asc)
    columns = []
    eval(Team.find(team).scout_schema.pit_data).each do |section|
      section[1].each do |field|
        columns.push(field[0])
      end
    end
    CSV.generate(headers: true) do |csv|
      csv << columns
      data.each do |entry|
        raw_data = eval(entry.data)
        processed = []
        raw_data.each do |rd|
          processed.push(rd[1])
        end

        csv << processed
      end
    end
  end
end
