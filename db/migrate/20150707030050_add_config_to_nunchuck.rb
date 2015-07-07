class AddConfigToNunchuck < ActiveRecord::Migration
  def change
    add_column :nunchucks, :config, :text
  end
end
