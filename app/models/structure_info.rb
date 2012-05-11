class StructureInfo < ActiveRecord::Base
  belongs_to :institute
  mount_uploader :logo, FileUploader
  mount_uploader :teachers_list, FileUploader
  mount_uploader :students_list, FileUploader
  validates  :name,:presence => true
  validates  :address,:presence => true
  validates  :start_class,:presence => true
  validates  :end_class,:presence => true
  validates  :max_section,:presence => true
  validates  :teachers_list,:presence => true
  validates  :students_list,:presence => true
end
