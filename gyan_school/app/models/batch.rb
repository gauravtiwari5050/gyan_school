class Batch < ActiveRecord::Base
  belongs_to :institute
  has_many :sections
end
