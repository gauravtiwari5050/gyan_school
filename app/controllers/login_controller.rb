include Util
class LoginController < ApplicationController
  before_filter :validate_institute_url
  def login
  end

  def login_employee
    logger.info params.inspect
    pass_hash = md5_hash(params[:password])
    username_or_email = params[:user_name]
    username_or_email.gsub!('_AT_','@')
    username_or_email.gsub!('_DOT_','.')

    employee = User.find(:first,:conditions => {:institute_id => get_institute_id,:email => username_or_email,:pass_hash => pass_hash})
    if employee.nil?
      employee = User.find(:first,:conditions => {:institute_id => get_institute_id,:username => username_or_email,:pass_hash => pass_hash})
      
    end
    respond_to do |format|
      if employee.nil?
        format.html {render :action => "login"}
        format.js {render :json => nil, :status => :unprocessable_entity}
      else
       login_employee_user(employee) 
       format.html {redirect_to(get_home_for_user)}
       format.js {render :json => nil, :status => :ok}
      end
    end

  end

  def login_student

  end
  def destroy
    logout_user
    respond_to do |format|
     format.html {redirect_to('/login')}
    end
  end

  def ajax_login
    logger.info params.inspect
    user_type = params[:user_type]
    if user_type == 'admin' || user_type == 'teacher' || user_type == 'employee'
     login_employee
    elsif user_type == 'student' || user_type == 'parent'
      login_student
    else

    end
    
  end
end
