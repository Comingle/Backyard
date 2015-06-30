class CreateNunchucks < ActiveRecord::Migration
  def change
    create_table :nunchucks do |t|
      t.integer "x_min", default: 0
      t.integer "x_max", default: 255
      t.integer "x_zero", default: 124
      t.integer "y_min", default: 0
      t.integer "y_max", default: 255
      t.integer "y_zero", default: 124
      t.integer "x_accel_min", default: 0
      t.integer "x_accel_max", default: 255
      t.integer "x_accel_zero", default: 510
      t.integer "y_accel_min", default: 0
      t.integer "y_accel_max", default: 255
      t.integer "y_accel_zero", default: 490
      t.integer "z_accel_min", default: 0
      t.integer "z_accel_max", default: 255
      t.integer "z_accel_zero", default: 460
      t.integer "radius", default: 210
      t.integer "pitch_min", default: 0
      t.integer "pitch_max", default: 255
      t.integer "roll_min", default: 0
      t.integer "roll_max", default: 255
      t.string "name", default: "Nunchuck"
      t.timestamps null: false
      t.belongs_to :user, index: true
    end
  end
end
