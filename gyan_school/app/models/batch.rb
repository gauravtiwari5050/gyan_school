class Batch < ActiveRecord::Base
  belongs_to :institute
  has_many :sections
  accepts_nested_attributes_for :sections
end
