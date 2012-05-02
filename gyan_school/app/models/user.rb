class User < ActiveRecord::Base
  USR_TYPE_OPTIONS = %w(ADMIN OFFICE ACCOUNTS TEACHER SUPPORT STUDENT)
  has_one :address,:as => :addressable,:dependent => :destroy
  belongs_to :institute
  validates :first_name,:presence => :true
  validates :last_name,:presence => :true
  validates :email,:presence => :true,:uniqueness =>:true
  validates :user_type ,:presence => true,:inclusion => {:in => USR_TYPE_OPTIONS}
  validates :username,:presence => :true
  validates :pass_hash,:presence => :true
  validates :institute_id,:presence => :true
  validates_format_of :email, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
end
