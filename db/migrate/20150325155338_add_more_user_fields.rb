class AddMoreUserFields < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :address, :string
    add_column :users, :avatar, :string
  end
end
