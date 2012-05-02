class HomeController < ApplicationController
  def home
  end
  def session_new
    @institute_session =  InstituteSession.new
  end
  def session_create
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
  
end
