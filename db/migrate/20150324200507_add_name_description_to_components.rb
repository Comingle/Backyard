class AddNameDescriptionToComponents < ActiveRecord::Migration
  def change
    add_column :components, :pretty_name, :string
    add_column :components, :description, :string
  end
end
