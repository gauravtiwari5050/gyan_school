class CreateFeeCollections < ActiveRecord::Migration
  def change
    create_table :fee_collections do |t|
      t.integer :user_id ,:null => :false
      t.integer :fee_collection_event_id ,:null => :false

      t.timestamps
    end
  end
end
