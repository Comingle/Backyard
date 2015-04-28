class CreateNunchucks < ActiveRecord::Migration
  def change
    create_table :nunchucks do |t|
      t.string :c_click
      t.string :c_double_click
      t.string :z_click
      t.string :z_double_click
      t.string :joy_x
      t.string :joy_y
      t.string :roll
      t.string :pitch
      t.string :accel_x
      t.string :accel_y
      t.string :accel_z
      t.timestamps null: false
      t.belongs_to :sketch, index: true
    end
  end
end
