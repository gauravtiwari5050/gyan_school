include Util
class ExamReminderJob < Struct.new(:section_id,:exam_id,:task_id)
  def perform
    
    section = Section.find_by_id(section_id)
    exam = Exam.find_by_id(exam_id)
    section.students.each do |student|
      send_exam_reminder(student,exam)
    end
  end
end
