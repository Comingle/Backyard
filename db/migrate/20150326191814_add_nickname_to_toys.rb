class AddNicknameToToys < ActiveRecord::Migration
  def change
    add_column :toys, :nickname, :string
  end
end
