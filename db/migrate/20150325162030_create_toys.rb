class CreateToys < ActiveRecord::Migration
  def change
    create_table :toys do |t|
      t.belongs_to :user, index: true
      t.belongs_to :sketch, index: true
      t.string :color
      t.string :model
      t.timestamps null: false
    end
  end
end
