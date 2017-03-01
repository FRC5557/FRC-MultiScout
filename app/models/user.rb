class User < ApplicationRecord
  has_one :team_registration
  has_many :pit_data
  has_many :match_data
  # Other available Devise modules are:
  # :lockable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable

  def team
    team_registration.team
  end

  def event
    team.event
  end

  def event_pit_data
    event.pit_data.where('user_id=? AND team_id=?', self.id, team.id)
  end

  def empty_event_pit_data
    event_pit_data.where('data IS NULL')
  end

  def has_match_scout_assignment?
    team.match_scout_assignments.has_value?(self.id)
  end

  def match_scout_assignment
    team.match_scout_assignments.key(self.id)
  end
end
