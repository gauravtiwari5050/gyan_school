class Institute < ActiveRecord::Base
  has_one :address ,:as => :addressable ,:dependent => :destroy
  has_many :institute_sessions ,:dependent => :restrict
  has_many :fee_collection_events
  has_one :admin
  has_many :teachers
  has_many :students
  has_many :employees
  has_many :batches
  has_many :courses
  validates :name,:presence => true
  validates :url,:presence => true
  validates_uniqueness_of :url
  accepts_nested_attributes_for :courses,:reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true

end
