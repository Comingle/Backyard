class CreateSketches < ActiveRecord::Migration
  def change
    create_table :sketches do |t|
      t.integer "size"
      t.string "build_dir"
      t.string "sha256"
      t.integer "num_users"
      t.integer "total_uses"
      t.string "config"
      t.timestamps null: false
    end
  end
end
