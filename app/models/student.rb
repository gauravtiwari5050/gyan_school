class Student < User
  validates :dob,:presence => :true
end
