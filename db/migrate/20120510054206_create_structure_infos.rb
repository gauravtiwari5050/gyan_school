class CreateStructureInfos < ActiveRecord::Migration
  def change
    create_table :structure_infos do |t|
      t.string :name
      t.text :address
      t.string :logo
      t.integer :start_class
      t.integer :end_class
      t.integer :max_section
      t.string :teachers_list
      t.string :students_list

      t.timestamps
    end
  end
end
