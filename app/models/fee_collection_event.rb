class FeeCollectionEvent < ActiveRecord::Base
  belongs_to :institute
  has_many :fee_collection_events
  validates :name,:presence => :true
  validates :due_date,:presence => :true
end
