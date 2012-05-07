class Exam < ActiveRecord::Base
  belongs_to :examable,:polymorphic => true
  has_many :exam_results
  validates :name,:presence => true
  validates :start,:presence => true
  validates :end,:presence => true
end
