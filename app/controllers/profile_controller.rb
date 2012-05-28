class ProfileController < ApplicationController
  def student_detail_edit
    @student = Student.find_by_id(params[:student_id])   
  end
  def student_detail_update
    @student = Student.find_by_id(params[:student_id])
    respond_to do |format|
      if @student.update_attributes(params[:student])
        flash[:notice] = 'Details updated successfuly'
        format.html{redirect_to('/profiles/students/'+@student.id.to_s+'/edit')}
      else
        format.html {render :action => "student_detail_edit"}
      end
    end
    
  end

  def password_edit
    @student = Student.find_by_id(params[:student_id])   
    
  end

  def password_update
    logger.info params.inspect
    @student = Student.find_by_id(params[:student_id])
    success = true
    msg = ''
    if params[:password] != params[:confirm_password]
      success = false
      msg = 'Passwords dont match . Please try again'
    end
    if success == true
      success = @student.update_attribute(:pass_hash,md5_hash(params[:password])) 
      if !success
        msg = 'Something went wrong while updating the password. Please try again.'
        logger.error @student.errors.inspect
      end
    end

    respond_to do |format|
      if !success
        flash[:alert] = msg
        logger.info 'Errored with ' + msg 
      else
        flash[:notice] = 'Password updated successfuly'

      end
        format.html { redirect_to('/profiles/students/' + @student.id.to_s + '/reset_password')}
    end

    
  end


  def profile_picture_update
    success = true
    @student = Student.find_by_id(params[:student_id])   
    @profile = Profile.new(params[:profile])
    success =  true
    if @student.profile.nil?
      @profile.user_id = @student.id
      success = @profile.save
    else
      success = @student.profile.update_attributes(params[:profile])
    end

    respond_to do |format|
      logger.info 'rendering'
      if success
        flash[:notice] = 'Profile Pic changed. Please alow for sometime for the changes to propagate'
      else
        flash[:alert] = 'Profile Pic changed. Please alow for sometime for the changes to propagate'
      end
      format.html {redirect_to ('/profiles/students/'+@student.id.to_s+'/change_picture')}
    end

    
  end

end
