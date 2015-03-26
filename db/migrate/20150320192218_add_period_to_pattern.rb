class AddPeriodToPattern < ActiveRecord::Migration
  def change
    add_column :components, :period, :integer
  end
end
