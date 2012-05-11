class Course < ActiveRecord::Base
  belongs_to :batch
  has_many :exam_results
end
