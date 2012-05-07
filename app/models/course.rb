class Course < ActiveRecord::Base
  belongs_to :institute
  has_many :exam_results
end
