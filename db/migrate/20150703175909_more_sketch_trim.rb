class MoreSketchTrim < ActiveRecord::Migration
  def change
    remove_column :sketches, :model
    remove_column :sketches, :hid
  end
end
