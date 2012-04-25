class Employee < ActiveRecord::Base
  EMP_TYPE_OPTIONS = %w(ADMIN OFFICE ACCOUNTS TEACHER SUPPORT)
  has_one :address,:as => :addressable,:dependent => :destroy
  validates :first_name,:presence => :true
  validates :last_name,:presence => :true
  validates :email,:presence => :true
  validates :emp_type ,:presence => true,:inclusion => {:in => EMP_TYPE_OPTIONS}
  validates :username,:presence => :true
  validates :pass_hash,:presence => :true
  validates :institute_id,:presence => :true
  validates_format_of :email, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
end
