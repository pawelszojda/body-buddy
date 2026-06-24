class CreateMeasurementEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :measurement_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :weight, precision: 5, scale: 2, null: false
      t.decimal :body_fat, precision: 4, scale: 2
      t.decimal :calf, precision: 5, scale: 2
      t.decimal :thigh, precision: 5, scale: 2
      t.decimal :buttocks, precision: 5, scale: 2
      t.decimal :waist, precision: 5, scale: 2
      t.decimal :abdomen, precision: 5, scale: 2
      t.decimal :chest, precision: 5, scale: 2
      t.decimal :biceps, precision: 5, scale: 2
      t.decimal :forearm, precision: 5, scale: 2
      t.integer :mood
      t.integer :sleep_quality
      t.integer :bristol_stool_type
      t.string :stool_color
      t.text :note

      t.timestamps
    end
  end
end
