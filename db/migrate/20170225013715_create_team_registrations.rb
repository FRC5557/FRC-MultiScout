class CreateTeamRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :team_registrations do |t|
      t.references :team
      t.references :user
      t.boolean :denied, default: false

      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
