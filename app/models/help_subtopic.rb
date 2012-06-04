class HelpSubtopic < ActiveRecord::Base
  belongs_to :help_topic
  has_many :help_steps,:dependent =>:destroy
  accepts_nested_attributes_for :help_steps, :allow_destroy => true
end
