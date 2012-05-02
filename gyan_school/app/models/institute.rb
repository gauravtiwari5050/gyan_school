class Institute < ActiveRecord::Base
  has_one :address ,:as => :addressable ,:dependent => :destroy
  has_many :institute_sessions ,:dependent => :restrict
  has_one :admin
  has_many :teachers
  has_many :students
  has_many :employees
  has_many :batches
  validates :name,:presence => true
  validates :url,:presence => true
  validates_uniqueness_of :url

end
