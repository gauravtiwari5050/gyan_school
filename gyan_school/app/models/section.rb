class Section < ActiveRecord::Base
  belongs_to :batch
  has_many :students
  has_one :teacher
end
