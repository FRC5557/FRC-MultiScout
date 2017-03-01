class CreateMatchData < ActiveRecord::Migration[5.0]
  def change
    create_table :match_data do |t|
      t.references :team
      t.references :event
      t.references :user

      t.integer :competition_stage, null: false
      t.integer :set_number, null: false
      t.integer :match_number, null: false
      t.integer :team_number, null: false
      t.string :station
      t.string :match_time

      t.text :data

      t.timestamps
    end
  end
end
