class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.belongs_to :sketch, index: true
      t.belongs_to :component, index: true
      t.string :key
      t.string :value
      t.timestamps null: false
    end
  end
end
