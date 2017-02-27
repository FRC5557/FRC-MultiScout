class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :key, null: false
      t.string :name, null: false
      t.date :start_date
      t.date :end_date
      t.string :website

      t.timestamps
    end

    add_index :events, :key, unique: true
  end
end
