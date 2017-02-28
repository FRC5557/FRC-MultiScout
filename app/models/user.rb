class User < ApplicationRecord
  has_one :team_registration
  has_many :pit_data
  # Other available Devise modules are:
  # :lockable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable
end
