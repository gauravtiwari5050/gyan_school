class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :get_all_courses_for_institute,:get_all_courses_for_teacher,:get_all_courses_for_user,:get_home_for_user,:get_user_type,:get_programs_hash_for_institute,:join_channel,:join_collaboration,:current_user,:get_current_institute,:get_user_by_user_id,:get_students_for_course,:get_instructors_for_course,:is_user_profile_complete,:get_institute_base_url,:get_course_groups_for_user,:get_department_link_for_user,:is_student_present,:get_thumbnail_from_video
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
  



end
