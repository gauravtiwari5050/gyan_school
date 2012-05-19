include Util
class ExamResultNotificationJob < Struct.new(:section_id,:exam_id,:subject_id,:task_id)
  def perform
    
    section = Section.find_by_id(section_id)
    exam = Exam.find_by_id(exam_id)
    subject = Course.find_by_id(subject_id)
    results = ExamResult.find(:all,:conditions => {:section_id => section.id,:exam_id => exam_id,:course_id=> subject_id}) 
    user_ids = results.map(&:user_id)
    section.students.each do |student|
      if user_ids.include?(student.id)
        send_result_notification_sms(student,subject)
      end
    end
  end
end
