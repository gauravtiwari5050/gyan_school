class Student < User
  validates :dob,:presence => :true
  validates :section_id,:presence => :true
end
