class AddJsonToOptions < ActiveRecord::Migration
  def change
    remove_column :options, :key
    remove_column :options, :value
    add_column :options, :kv, :text
  end
end
