class CreateUserDetails < ActiveRecord::Migration
  def change
    create_table :user_details do |t|
      t.string :gender
      t.string :blood_group
      t.string :birth_place
      t.string :nationality
      t.string :mother_tongue
      t.string :category
      t.string :religion

      t.timestamps
    end
  end
end
