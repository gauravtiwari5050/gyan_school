class RenameEmployeesToUsers < ActiveRecord::Migration
  def change
    rename_table :employees, :users
  end
end
