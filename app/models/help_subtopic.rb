class HelpSubtopic < ActiveRecord::Base
  belongs_to :help_topic
  mount_uploader :support_file, FileUploader
  has_many :help_steps,:dependent =>:destroy
  accepts_nested_attributes_for :help_steps,:reject_if => lambda { |a| a[:content].blank? || a[:order].blank? }, :allow_destroy => true
end
