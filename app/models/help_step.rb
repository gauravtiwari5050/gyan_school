class HelpStep < ActiveRecord::Base
  belongs_to :help_subtopics
  validates :order,:presence => true
  validates :title,:presence => true
  validates :content,:presence => true

end
