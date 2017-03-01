class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.integer :number, null: false
      t.string :name

      t.references :scout_schema
      t.references :event
      t.string :scout_assignments

      t.timestamps
    end
  end
end
