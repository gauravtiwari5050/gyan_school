class ProfileController < ApplicationController
  def user_detail_edit
    @user = User.find_by_id(params[:user_id])
    if @user.address.nil?
      @user.build_address
    end
    if @user.type == 'Student' && @user.user_detail.nil?
      @user.build_user_detail
    end
  end
  def user_detail_update
    logger.info params.inspect
    @user = User.find_by_id(params[:user_id])
    respond_to do |format|
      if @user.update_attributes(params[@user.type.downcase])
        flash[:notice] = 'Details updated successfuly'
        format.html{redirect_to('/profiles/'+@user.id.to_s+'/edit')}
      else
        format.html {render :action => "user_detail_edit"}
      end
    end
    
  end

  def password_edit
    @user = User.find_by_id(params[:user_id])   
  end

  def password_update
    logger.info params.inspect
    @user = User.find_by_id(params[:user_id])
    success = true
    msg = ''
    if params[:password] != params[:confirm_password]
      success = false
      msg = 'Passwords dont match . Please try again'
    end
    if success == true
      success = @user.update_attribute(:pass_hash,md5_hash(params[:password])) 
      if !success
        msg = 'Something went wrong while updating the password. Please try again.'
        logger.error @user.errors.inspect
      end
    end

    respond_to do |format|
      if !success
        flash[:alert] = msg
        logger.info 'Errored with ' + msg 
      else
        flash[:notice] = 'Password updated successfuly'

      end
        format.html { redirect_to('/profiles/' + @user.id.to_s + '/reset_password')}
    end

    
  end



  def user_profile
    @user = User.find_by_id(params[:user_id])
  end

end
