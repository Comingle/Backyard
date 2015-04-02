class AddDefaultsToSketches < ActiveRecord::Migration
  def change
    change_column :sketches, :hid, :boolean, :default => false
    change_column :sketches, :serial_console, :boolean, :default => true
  end
end
