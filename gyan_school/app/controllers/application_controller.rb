class ApplicationController < ActionController::Base
  protect_from_forgery
  def login_employee_user(user)
    session[:user_institute_id] = user.institute_id
    session[:user_name] = user.username
    session[:user_type] = user.emp_type
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
  



end
