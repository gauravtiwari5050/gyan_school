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

  helper_method :get_all_courses_for_institute,:get_all_courses_for_teacher,:get_all_courses_for_user,:get_home_for_user,:get_user_type,:get_programs_hash_for_institute,:join_channel,:join_collaboration,:current_user,:get_current_institute,:get_user_by_user_id,:get_students_for_course,:get_instructors_for_course,:is_user_profile_complete,:get_institute_base_url,:get_course_groups_for_user,:get_department_link_for_user,:is_student_present,:get_thumbnail_from_video,:get_batches_for_institute,:create_user_name,:get_section_description,:is_fee_paid,:get_score,:get_institute_id,:get_teacher_for_section
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
    end

    session[:institute_id] = institute.id

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
      return true
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


end
