class FeeCollection < ActiveRecord::Base
  belongs_to :user
  belongs_to :fee_collection_event
end
