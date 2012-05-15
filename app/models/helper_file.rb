class HelperFile < ActiveRecord::Base
  belongs_to :institute
  mount_uploader :name, FileUploader
  validates :name,:presence => true
end
