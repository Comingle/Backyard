class AddMoreInfoToSketches < ActiveRecord::Migration
  def change
    add_column :sketches, :model, :string
    add_column :sketches, :hid, :boolean
    add_column :sketches, :serial_console, :boolean
    add_column :sketches, :startup_sequence, :string
    add_column :sketches, :click, :string
    add_column :sketches, :doubleclick, :string
    add_column :sketches, :longpressstart, :string
  end
end
