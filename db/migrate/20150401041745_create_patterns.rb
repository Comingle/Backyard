class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.string :global
      t.string :setup
      t.string :loop
      t.integer :motor0
      t.integer :motor1
      t.integer :motor2
      t.integer :on
      t.integer :off
      t.integer :time
      t.timestamps null: false
      t.belongs_to :sketch, index: true
      t.belongs_to :component, index: true
    end
  end
end
