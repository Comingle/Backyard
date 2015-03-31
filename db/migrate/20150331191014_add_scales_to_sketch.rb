class AddScalesToSketch < ActiveRecord::Migration
  def change
    add_column :sketches, :time_scale, :float
    add_column :sketches, :power_scale, :float
  end
end
