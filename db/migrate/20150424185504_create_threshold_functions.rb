class CreateThresholdFunctions < ActiveRecord::Migration
  def change
    create_table :threshold_functions do |t|
      t.string :source
      t.float :step_size
      t.integer :base_thresh_low
      t.integer :base_thresh_high
      t.integer :thresh
      t.string :source_function
      t.string :increase
      t.boolean :c_needed
      t.string :increase_with_c
      t.boolean :z_needed
      t.string :increase_with_z
      t.string :decrease
      t.string :decrease_with_c
      t.string :decrease_with_z
      t.timestamps null: false
      t.belongs_to :nunchuck, index: true
    end
  end
end
