include Util
class FeesReminderJob < Struct.new(:fee_collection_event_id,:institute_id,:task_id)
  def perform
   
    fee_collection_event = FeeCollectionEvent.find_by_id(fee_collection_event_id)
    institute = Institute.find_by_id(institute_id)
    if !fee_collection_event.nil? && !institute.nil?
       fee_collections = fee_collection_event.fee_collections
       user_ids = fee_collections.map(&:user_id)
       institute.students.each do |student|
         
        if !user_ids.include?(student.id)
          send_fees_reminder(student,fee_collection_event)
        end
       end

    end
  end
end
