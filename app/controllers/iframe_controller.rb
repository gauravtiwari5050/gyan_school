class IframeController < ApplicationController
  def change_user_picture
    @user = User.find_by_id(params[:user_id])   
    @profile = Profile.new
  end
  def profile_picture_update
    success = true
    @user = User.find_by_id(params[:user_id])   
    @profile = Profile.new(params[:profile])
    success =  true
    if @user.profile.nil?
      @profile.user_id = @user.id
      success = @profile.save
    else
      success = @user.profile.update_attributes(params[:profile])
    end

    respond_to do |format|
      logger.info 'rendering'
      if success
        flash[:notice] = 'Profile Pic changed. Please alow for sometime for the changes to propagate'
      else
        flash[:alert] = 'Error uploading file please try again'
      end
      format.html {redirect_to ('/iframe/close')}
    end

    
  end

  def close

  end
end
