class Address < ActiveRecord::Base
  belongs_to :addressable,:polymorphic => true
  validates :address_1,:presence => :true
  validates :mobile,:presence => :true

end
