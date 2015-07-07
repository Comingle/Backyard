class TrimSketch < ActiveRecord::Migration
  def change
    remove_column :sketches, :time_scale
    remove_column :sketches, :power_scale
    remove_column :sketches, :startup_sequence
    remove_column :sketches, :serial_console
    remove_column :sketches, :click
    remove_column :sketches, :doubleclick
    remove_column :sketches, :longpressstart
  end
end
