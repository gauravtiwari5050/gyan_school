class User < ActiveRecord::Base
  USR_TYPE_OPTIONS = %w(ADMIN OFFICE ACCOUNTS TEACHER SUPPORT STUDENT)
  has_one :address,:as => :addressable,:dependent => :destroy
  has_one :admission_detail
  belongs_to :institute
  belongs_to :section
  validates :first_name,:presence => :true
  validates :last_name,:presence => :true
  validates :email,:presence => :true,:uniqueness =>:true
  validates :user_type ,:presence => true,:inclusion => {:in => USR_TYPE_OPTIONS}
  validates :username,:presence => :true
  validates :pass_hash,:presence => :true
  validates :institute_id,:presence => :true
  accepts_nested_attributes_for :admission_detail
end
