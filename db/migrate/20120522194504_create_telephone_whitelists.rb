class CreateTelephoneWhitelists < ActiveRecord::Migration
  def change
    create_table :telephone_whitelists do |t|
      t.string :number

      t.timestamps
    end
  end
end
