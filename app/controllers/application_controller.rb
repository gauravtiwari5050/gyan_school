class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :correct_safari_and_ie_accept_headers
  after_filter :set_xhr_flash
  def set_xhr_flash
    flash.discard if request.xhr?
  end

  def correct_safari_and_ie_accept_headers
    ajax_request_types = ['text/javascript', 'application/json', 'text/xml']
    request.accepts.sort! { |x, y| ajax_request_types.include?(y.to_s) ? 1 : -1 } if request.xhr?
  end

  helper_method :get_home_for_user,:get_user_type,:current_user,:get_current_institute,:get_students_for_course,:is_user_profile_complete,:get_institute_base_url,:is_student_present,:get_batches_for_institute,:create_user_name,:get_section_description,:is_fee_paid,:get_score,:get_institute_id,:get_teacher_for_section,:get_profile_pic_for_user,:get_max_score,:get_current_session,:get_attendance_report,:get_fees_report,:get_sections_for_teacher
  def login_employee_user(user)
    session[:user_institute_id] = user.institute_id
    session[:user_name] = user.username
    session[:user_type] = user.user_type
    session[:is_logged_in] = true
    session[:user_id] = user.id
  end
  
  def logout_user
    session[:user_institute_id] = nil
    session[:user_name] = nil
    session[:user_type] = nil
    session[:is_logged_in] = false
    session[:user_id] = nil
  end
  def get_institute_id
    institute_id = session[:institute_id]
    if institute_id.nil?
      validate_institute_url
    end
    return institute_id
  end
  def validate_institute_url
    # add another function to validate url for logged in user
    current_host = request.host.split(".")[0]
    
    institute = Institute.find_by_url(current_host)
    if institute.nil?
      redirect_to (GyanSchool::Application.config.landing_page.to_s)
    else
     session[:institute_id] = institute.id
    end

  end
  def get_home_for_user
    return '/home'
  end

  def current_user
    #TODO current employee
    return User.find(session[:user_id])
  end
  def get_user_type
    return session[:user_type]
  end
  
  def get_batches_for_institute
    @institute = Institute.find_by_id(get_institute_id)
    return @institute.batches
  end
  def create_user_name(first,middle,last)
    return 'dummy'
  end

  def get_section_description(section_id)
    section = Section.find_by_id(section_id)
    return section.batch.name + "-" + section.name
  end
  def is_student_present (student_id,section_id,date)
    attendance = SectionAttendance.find(:first,:conditions => {:user_id => student_id,:section_id => section_id,:date=>date})
    if attendance.nil?
      return false
    else
      return attendance.present
    end
  end

  def is_fee_paid(student_id,event_id)
        fee_collection = FeeCollection.find(:first,:conditions => {:user_id=>student_id,:fee_collection_event_id=>event_id} )
        return !fee_collection.nil?
    
  end

  def get_score(section_id,user_id,exam_id,course_id)
     exam_result = ExamResult.find(:first,:conditions=> {:section_id => section_id,:user_id => user_id,:exam_id => exam_id,:course_id => course_id})
     return exam_result
  end

  def get_max_score(section_id,exam_id,course_id)
     exam_result = ExamResult.find(:first,:conditions=> {:section_id => section_id,:exam_id => exam_id,:course_id => course_id})
     if exam_result.nil?
      return ''
     else
      return exam_result.total.to_s
     end
  end

  def get_teacher_for_section(section)
    teacher = nil
    if !section.nil?
     teacher_section = TeacherSection.find(:first,:conditions=>{:institute_id => get_institute_id,:section_id => section.id}) 
     if !teacher_section.nil?
      teacher = teacher_section.user
     end
    end
    return teacher
  end

  def get_profile_pic_for_user(user)
    if user.type == 'Admin'
      return 'user_128.gif'
      
    elsif user.type == 'Teacher'
      return 'teacher.png'

    elsif user.type == 'Student'
      return 'student.png'

    elsif user.type == 'Employee'
      return 'employee.png'

    end
  end

  def get_current_session
     @institute = Institute.find_by_id(get_institute_id)
     current_session =  @institute.institute_sessions.find(:first,:conditions => {:current => true})
     if current_session.nil?
     #TODO redirect her
     end

     return current_session

  end

  def get_attendance_report(student,session)
    if student.nil? || session.nil?
      logger.info 'not generating report'
      return nil
    end
    logger.info 'generating attendance report for ' + student.print_name
    attendances = SectionAttendance.find(:all,:conditions => {:user_id => student.id,:institute_session_id => session.id})
    report = Hash.new
    attendances.each do |attendance|
      month = attendance.date.strftime("%B")
      if report[month].nil?
        report[month] = Hash.new
        report[month][:present] = 0
        report[month][:absent] = 0
      end
      if attendance.present
        report[month][:present] += 1
      else
        report[month][:absent] += 1
      end
    end

    return report
  end

  def get_fees_report(student,session)
    if student.nil? || session.nil?
      logger.info 'not generating report'
      return nil
    end
    logger.info 'generating fees report for ' + student.print_name
    fee_collection_events = FeeCollectionEvent.find(:all,:conditions => {:institute_id => get_institute_id})
    report = Hash.new
    if !fee_collection_events.nil?
      fee_collection_events.each do |event|
        fee_collection = FeeCollection.find(:first,:conditions => {:fee_collection_event_id => event.id,:user_id => student.id})
        month = event.due_date.strftime("%B")
        if !fee_collection.nil?
         report[month] =  true  
        else
         report[month] =  false  
        end
      end
    end

    return report
    
  end

  def get_sections_for_teacher(teacher)
    if teacher.nil?
      return nil
    end
    teacher_sections = TeacherSection.find(:all,:conditions => {:institute_id => get_institute_id,:user_id => teacher.id})
    return teacher_sections
  end

  def section_delete(section)
      teacher_sections = TeacherSection.find(:all,:conditions => {:section_id => section.id,:institute_id => get_institute_id})
      teacher_sections.each do |teacher_section|
        teacher_section.destroy
      end
      section.destroy
    
  end


end
