class Add < ActiveRecord::Migration
  def change 
    add_column :user_details,:user_id,:integer
  end

end
