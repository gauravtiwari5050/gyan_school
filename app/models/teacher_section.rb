class TeacherSection < ActiveRecord::Base
  belongs_to :institute
  belongs_to :user
end
