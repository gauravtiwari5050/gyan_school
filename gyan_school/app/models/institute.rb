class Institute < ActiveRecord::Base
  has_one :address ,:as => :addressable ,:dependent => :destroy
  has_many :institute_sessions ,:dependent => :restrict
  has_many :users
  validates :name,:presence => true
  validates :url,:presence => true
  validates_uniqueness_of :url

end
