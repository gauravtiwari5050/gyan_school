class FeeCollectionEvent < ActiveRecord::Base
  belongs_to :institute
  validates :name,:presence => :true
  validates :due_date,:presence => :true
end
