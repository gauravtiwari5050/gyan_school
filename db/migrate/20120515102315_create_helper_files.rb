class CreateHelperFiles < ActiveRecord::Migration
  def change
    create_table :helper_files do |t|
      t.string :name
      t.integer :institute_id

      t.timestamps
    end
  end
end
