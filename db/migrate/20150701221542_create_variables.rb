class CreateVariables < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      t.string "name"
      t.string "description"
      t.integer "min"
      t.integer "max"
      t.timestamps null: false
    end
  end
end
