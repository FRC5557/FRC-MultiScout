class CreateScoutSchemas < ActiveRecord::Migration[5.0]
  def change
    create_table :scout_schemas do |t|
      t.string :name, null: false
      t.text :data, null: false, default: "{}"
      t.boolean :is_official, default: false

      t.timestamps
    end

    add_index :scout_schemas, :name, unique: true
  end
end
