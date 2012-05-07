class Batch < ActiveRecord::Base
  belongs_to :institute
  has_many :sections
  validates :name,:presence => :true
  accepts_nested_attributes_for :sections,:reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
end
