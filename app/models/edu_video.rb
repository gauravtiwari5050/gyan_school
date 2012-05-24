class EduVideo < ActiveRecord::Base
  attr_accessible :subject,:topic,:subtopic,:description
  searchable do
    text :subject,:boost => 5
    text :topic,:subtopic,:description
  end
end
