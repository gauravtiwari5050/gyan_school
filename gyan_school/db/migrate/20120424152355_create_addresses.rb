class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_1
      t.string :address_2
      t.string :address_3
      t.string :city
      t.string :district
      t.string :state
      t.string :pincode
      t.string :landmark
      t.string :phone
      t.string :mobile
      t.references :addressable, :polymorphic => true

      t.timestamps
    end
  end
end
