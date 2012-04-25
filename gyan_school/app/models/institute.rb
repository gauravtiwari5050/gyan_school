class Institute < ActiveRecord::Base
  has_one :address ,:as => :addressable ,:dependent => :destroy
  validates :name,:presence => true
  validates :url,:presence => true
  validates_uniqueness_of :url
end
