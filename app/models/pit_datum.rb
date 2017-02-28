class PitDatum < ApplicationRecord
  belongs_to :team
  belongs_to :event
  belongs_to :user
end
