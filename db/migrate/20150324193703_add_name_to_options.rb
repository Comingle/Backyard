class AddNameToOptions < ActiveRecord::Migration
  def change
    add_column :options, :component_name, :string
  end
end
