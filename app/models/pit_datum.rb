class PitDatum < ApplicationRecord
  require 'csv'
  belongs_to :team
  belongs_to :event
  belongs_to :user

  def self.to_csv(team, event)
    data = all.where(team_id: team, event_id: event).where('data IS NOT NULL').order(number: :asc)
    columns = ['Team number']
    eval(Team.find(team).scout_schema.pit_data).each do |section|
      section[1].each do |field|
        columns.push(field[0].gsub('_', ' ').capitalize)
      end
    end
    CSV.generate(headers: true) do |csv|
      csv << columns
      data.each do |entry|
        raw_data = eval(entry.data)
        processed = [entry.number.to_s]
        raw_data.each do |rd|
          processed.push(rd[1])
        end

        csv << processed
      end
    end
  end
end
