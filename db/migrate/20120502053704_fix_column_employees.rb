class FixColumnEmployees < ActiveRecord::Migration
  def up
    rename_column :employees, :emp_type, :user_type
  end

  def down
    rename_column :employees, :user_type, :emp_type
  end
end
