class HelpStep < ActiveRecord::Base
  belongs_to :help_subtopics
  validates :order,:presence => true
  validates :content,:presence => true
  mount_uploader :support_image, FileUploader

end
