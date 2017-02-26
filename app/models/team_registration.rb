class TeamRegistration < ApplicationRecord
  belongs_to :team
  belongs_to :user

  def current_reg?
    !denied && !confirmed_at.nil?
  end
end
