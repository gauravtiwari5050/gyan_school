include Util
class LoginController < ApplicationController
  before_filter :validate_institute_url
  def login
  end

  def login_employee
    logger.info params.inspect
    pass_hash = md5_hash(params[:password])
    username_or_email = params[:user_name]
    employee = User.find(:first,:conditions => {:institute_id => get_institute_id,:email => username_or_email,:pass_hash => pass_hash})
    if employee.nil?
      employee = User.find(:first,:conditions => {:institute_id => get_institute_id,:username => username_or_email,:pass_hash => pass_hash})
      
    end
    respond_to do |format|
      if employee.nil?
        format.html {render :action => "login"}
      else
       login_employee_user(employee) 
       format.html {redirect_to(get_home_for_user)}
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
end
