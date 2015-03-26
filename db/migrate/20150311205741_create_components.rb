class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string  "name"
      t.string  "scope"
      t.string  "category"
      t.integer "use_count"
      t.string  "data"
      t.timestamps null: false
    end
  end
end
