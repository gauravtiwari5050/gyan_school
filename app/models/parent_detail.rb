class ParentDetail < ActiveRecord::Base
  belongs_to :user
  validates :name,:presence => :true
  validates :mobile,:presence => :true
end
