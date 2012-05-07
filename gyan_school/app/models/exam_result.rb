class ExamResult < ActiveRecord::Base
  belongs_to :exam
  belongs_to :section
  belongs_to :user
  belongs_to :course
end
