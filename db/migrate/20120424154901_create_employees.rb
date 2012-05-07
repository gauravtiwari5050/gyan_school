class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :email
      t.string :emp_type
      t.string :username
      t.string :pass_hash

      t.timestamps
    end
  end
end
