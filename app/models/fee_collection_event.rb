class FeeCollectionEvent < ActiveRecord::Base
  belongs_to :institute
  has_many :fee_collections
  validates :name,:presence => :true
  validates :due_date,:presence => :true
end
