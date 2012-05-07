class InstituteSession < ActiveRecord::Base
  belongs_to :institute
  validates :institute_id,:presence => :true
  validates :start,:presence => :true
  validates :end,:presence => :true
  validates :current,:presence => :true

end
