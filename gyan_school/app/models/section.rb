class Section < ActiveRecord::Base
  belongs_to :batch
  has_many :students
  has_one :teacher
  has_many :exams,:as => :examable
  has_many :exam_results
  accepts_nested_attributes_for :exams,:reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
end
