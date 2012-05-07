class AddOneTimeLginToEmployees < ActiveRecord::Migration
  def change
    add_column :employees,:one_time_login,:string
  end
end
