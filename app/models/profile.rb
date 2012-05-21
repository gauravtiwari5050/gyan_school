class Profile < ActiveRecord::Base
  belongs_to :user
  mount_uploader :image, S3Uploader
  validates :image,:presence => true
end
