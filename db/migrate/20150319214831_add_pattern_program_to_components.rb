class AddPatternProgramToComponents < ActiveRecord::Migration
  def change

    add_column :components, :testride, :string
  end
end
