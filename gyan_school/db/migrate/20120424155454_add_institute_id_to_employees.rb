class AddInstituteIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees,:institute_id,:integer
  end
end
