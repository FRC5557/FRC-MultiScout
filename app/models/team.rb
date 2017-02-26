class Team < ApplicationRecord
  has_many :team_registrations
  belongs_to :scout_schema

  def confirmed_members
    team_registrations.where('confirmed_at IS NOT NULL AND denied=false')
  end

  def unconfirmed_members
    team_registrations.where('confirmed_at IS NULL AND denied=false')
  end
end
