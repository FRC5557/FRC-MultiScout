class CreatePitData < ActiveRecord::Migration[5.0]
  def change
    create_table :pit_data do |t|
      t.references :team
      t.references :event
      t.references :user

      t.integer :number, null: false
      t.text :data

      t.timestamps
    end

    add_index :pit_data, :number, unique: true
  end
end
