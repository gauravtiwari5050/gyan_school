class CreateParentDetails < ActiveRecord::Migration
  def change
    create_table :parent_details do |t|
      t.integer :user_id
      t.string :name
      t.string :email
      t.string :phone
      t.string :mobile

      t.timestamps
    end
  end
end
