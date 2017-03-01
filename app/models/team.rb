class Team < ApplicationRecord
  has_many :team_registrations
  has_many :pit_data
  has_many :match_data
  belongs_to :scout_schema
  belongs_to :event

  def confirmed_members
    team_registrations.where('confirmed_at IS NOT NULL AND denied=false')
  end

  def unconfirmed_members
    team_registrations.where('confirmed_at IS NULL AND denied=false')
  end

  def match_scout_assignments
    eval(scout_assignments)
  end
end
