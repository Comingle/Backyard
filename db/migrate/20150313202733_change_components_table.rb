class ChangeComponentsTable < ActiveRecord::Migration
  def change
    rename_column :components, :data, :global
    remove_column :components, :scope
    add_column :components, :setup, :string
    add_column :components, :loop, :string
  end
end
