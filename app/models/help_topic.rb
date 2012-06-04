class HelpTopic < ActiveRecord::Base
   validates :order,:presence => true
   validates :name,:presence => true
   has_many :help_subtopics,:dependent => :destroy
  accepts_nested_attributes_for :help_subtopics,:reject_if => lambda { |a| a[:content].blank? || a[:order].blank? }, :allow_destroy => true
end
