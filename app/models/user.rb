class User < ApplicationRecord
  has_one :team_registration
  has_many :pit_data
  # Other available Devise modules are:
  # :lockable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable

  def event_pit_data
    team_registration.team.event.pit_data.where('user_id=?',self.id)
  end

  def empty_event_pit_data
    event_pit_data.where('data IS NULL')
  end
end
