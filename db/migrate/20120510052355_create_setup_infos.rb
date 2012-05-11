class CreateSetupInfos < ActiveRecord::Migration
  def change
    create_table :setup_infos do |t|
      t.integer :institute_id
      t.string :status
      t.string :comment

      t.timestamps
    end
  end
end
