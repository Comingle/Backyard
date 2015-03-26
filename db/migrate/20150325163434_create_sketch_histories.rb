class CreateSketchHistories < ActiveRecord::Migration
  def change
    create_table :sketch_histories do |t|

      t.belongs_to :toy, index: true
      t.belongs_to :sketch, index: true

      t.timestamps null: false
    end
  end
end
