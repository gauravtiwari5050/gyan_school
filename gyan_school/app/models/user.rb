class User < ActiveRecord::Base
  USR_TYPE_OPTIONS = %w(CURRENT PREVIOUS PENDING)
  has_one :address,:as => :addressable,:dependent => :destroy
  has_one :admission_detail
  has_one :user_detail
  has_one :parent_detail
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
  accepts_nested_attributes_for :user_detail
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :parent_detail
  def fullname
    fullname = ''
    fullname += self.first_name
    if !self.middle_name.nil?
      fullname += ' ' + self.middle_name
    end
    fullname += self.last_name
    if !self.email.nil?
      fullname += '(' + self.email + ')'
    end


  end
end
