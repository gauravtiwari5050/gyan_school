class HomeController < ApplicationController
  def home
  end
  def session_new
    @institute_session =  InstituteSession.new
  end
  def session_create
    logger.info params.inspect
    @institute_session = InstituteSession.new(params[:institute_session])
    logger.info @institute_session.inspect
    @institute_session.institute_id =  get_institute_id

    persist_success = @institute_session.save
    respond_to do |format|
      if persist_success
        format.html {redirect_to('/sessions/index')}
      else
        format.html {render :action => "session_new"}
      end
    end

  end

  def session_index
    @institute = Institute.find_by_id(get_institute_id)
  end

  def session_edit
    @institute = Institute.find_by_id(get_institute_id)
    @institute_session = InstituteSession.find_by_id(params[:session_id])
    if @institute_session.institute_id != @institute.id
      flash[:error] = 'You do not have permission to view the page requested'
      redirect_to(get_home_for_user)
    end
    
  end

  def session_update
    @institute = Institute.find_by_id(get_institute_id)
    @institute_session = InstituteSession.find_by_id(params[:session_id])
    if @institute_session.institute_id != @institute.id
      flash[:error] = 'You do not have permission to view the page requested'
      redirect_to(get_home_for_user)
    end

    respond_to do |format|
      if @institute_session.update_attributes(params[:institute_session])
        format.html {redirect_to('/sessions/index')}
      else
        format.html {render :action => "session_edit"}
        
      end
    end
    
  end

  def session_delete
    @institute = Institute.find_by_id(get_institute_id)
    @institute_session = InstituteSession.find_by_id(params[:session_id])
    if @institute_session.institute_id != @institute.id
      flash[:error] = 'You do not have permission to view the page requested'
      redirect_to(get_home_for_user)
    end
    @institute_session.destroy #TODO check if this is actualy destroyed
    respond_to do |format|
      format.html {redirect_to('/sessions/index')}
    end

    
  end
  
end
