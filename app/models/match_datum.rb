class MatchDatum < ApplicationRecord
  require 'csv'
  belongs_to :team
  belongs_to :event
  belongs_to :user

  def self.to_csv(team, event)
    data = all.where(team_id: team, event_id: event).where('data IS NOT NULL').order(competition_stage: :asc, set_number: :asc, match_number: :asc)
    columns = ['Team number', 'Competition stage', 'Set number', 'Match number']
    eval(Team.find(team).scout_schema.match_data).each do |section|
      next if section[0] == 'alliances'
      section[1].each do |field|
        if field[1][0] == 'location'
          columns.push((field[0] + '_x').gsub('_', ' ').capitalize)
          columns.push((field[0] + '_y').gsub('_', ' ').capitalize)
        else
          columns.push(field[0].gsub('_', ' ').capitalize)
        end
      end
    end
    CSV.generate(headers: true) do |csv|
      csv << columns
      data.each do |entry|
        raw_data = eval(entry.data)
        processed = [entry.team_number.to_s, stage_number_to_name(entry.competition_stage), entry.set_number.to_s, entry.match_number.to_s]
        raw_data.each do |rd|
          output = rd[1]
          if rd[1] == true || rd[1] == false
            output = output ? 1 : 0
          end
          processed.push(output)
        end

        csv << processed
      end
    end
  end

  private
  def self.stage_number_to_name(num)
    case num
    when 3
      'Quarterfinals'
    when 5
      'Finals'
    when 1
      'Qualification'
    when 2
      'Eight-finals'
    when 4
      'Semifinals'
    end
  end
end
