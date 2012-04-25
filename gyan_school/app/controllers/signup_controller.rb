include Util
class SignupController < ApplicationController
  def signup
   logger.info params.inspect
  end

  def register
   logger.info params.inspect
   persist_success =  true
   institute_name = params[:institute_name]
   institute_url = params[:institute_url]
   msg = ''
   institute = Institute.new
   begin
    Employee.transaction do
      institute.name = params[:institute_name]
      institute.url = params[:institute_url]
      persist_success = institute.save
      if persist_success == false
        msg = 'Error Saving School information. Please select a unique url' 
        logger.error msg
        raise msg
      else
        employee = Employee.new
        employee.first_name = params[:first_name]
        employee.last_name = params[:last_name]
        employee.email = params[:contact_email]
        employee.emp_type = 'ADMIN'
        #employee.username = generate_user_name(params[:first_name],'',params[:last_name])
        employee.username = 'admin'
        employee.pass_hash = md5_hash(params[:password])
        employee.one_time_login = unique_id('')
        employee.institute_id = institute.id
        persist_success = employee.save
        if persist_success == false
          msg = 'Error Saving Admin information. Please try again'
          logger.error msg
          logger.error employee.errors.inspect
          raise msg
        end
      end
    end

    rescue Exception => e
        persist_success = false
        logger.error e.message
    end
    respond_to do|format|
      if persist_success
        format.html {redirect_to('http://'+institute.url.to_s+'.lvh.me:3000/login')}
      else
        format.html {render :action => "signup"}
      end
    end
  
   end



  end

