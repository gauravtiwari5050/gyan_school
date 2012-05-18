include Util
class AttendanceReportJob < Struct.new(:section_id,:date,:task_id)
  def perform
    
    section = Section.find_by_id(section_id)
    section_attendances = SectionAttendance.find(:all,:conditions => {:section_id => section.id,:date => date}) 
    user_ids = section_attendances.map(&:user_id)
    section.students.each do |student|
      if !user_ids.include?(student.id)
        send_absent_sms(student,date)
      end
    end
  end
end
