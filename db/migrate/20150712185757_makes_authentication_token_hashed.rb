class MakesAuthenticationTokenHashed < ActiveRecord::Migration
  def change
    rename_column :users, :authentication_token, :hashed_authentication_token
  end
end
