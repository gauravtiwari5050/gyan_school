class CreateAdmissionDetails < ActiveRecord::Migration
  def change
    create_table :admission_details do |t|
      t.string :admit_number
      t.date :admit_date
      t.integer :user_id

      t.timestamps
    end
  end
end
