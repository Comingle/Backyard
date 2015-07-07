class ChangeNunchuckDefaults < ActiveRecord::Migration
  def change
    change_column_default(:nunchucks, :x_min, 28)
    change_column_default(:nunchucks, :x_max, 230)
    change_column_default(:nunchucks, :y_min, 28)
    change_column_default(:nunchucks, :y_max, 230)
    change_column_default(:nunchucks, :x_accel_min, -433)
    change_column_default(:nunchucks, :x_accel_max, 513)
    change_column_default(:nunchucks, :x_accel_zero, 0)
    change_column_default(:nunchucks, :y_accel_min, -433)
    change_column_default(:nunchucks, :y_accel_max, 513)
    change_column_default(:nunchucks, :y_accel_zero, 0)
    change_column_default(:nunchucks, :z_accel_min, -433)
    change_column_default(:nunchucks, :z_accel_max, 513)
    change_column_default(:nunchucks, :z_accel_zero, 0)
    change_column_default(:nunchucks, :pitch_max, 180)
    change_column_default(:nunchucks, :roll_min, -100)
    change_column_default(:nunchucks, :roll_max, 100)
  end
end
