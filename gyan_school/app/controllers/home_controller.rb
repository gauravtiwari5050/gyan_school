include Util
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

  def batch_new
    @batch = Batch.new
    3.times {@batch.sections.build}
  end

  def batch_create
    logger.info params.inspect
    @batch = Batch.new(params[:batch])
    @batch.institute_id = get_institute_id
    persist_success = @batch.save
    respond_to do |format|
    if persist_success
      format.html {redirect_to("/batch/index")}
    else
      format.html {render :action => "batch_new"}
    end
    end
  end

  def batch_edit
    @institute = Institute.find_by_id(get_institute_id)
    @batch = Batch.find_by_id(params[:batch_id])
    respond_to do |format|
      format.html {render :action => "batch_new"}
    end
  end

  def batch_index
    @institute = Institute.find_by_id(get_institute_id)
  end

  def batch_update
    @institute = Institute.find_by_id(get_institute_id)
    @batch = Batch.find_by_id(params[:batch_id])
    respond_to do |format|
      if @batch.update_attributes(params[:batch])
        format.html {redirect_to('/batch/index')}
      else
        format.html {render :action => "batch_new"}
        
      end
    end
  end

  def student_new
    @institute = Institute.find_by_id(get_institute_id)
    @student = Student.new
    @student.build_admission_detail
    @student.build_user_detail
    @student.build_address
    @student.build_parent_detail
  end

  def student_create
    @institute = Institute.find_by_id(get_institute_id)
    logger.info params.inspect
    @student = Student.new(params[:student])
    @student.institute_id = @institute.id
    @student.user_type = "CURRENT"
    @student.username = create_user_name(@student.first_name,@student.middle_name,@student.last_name)
    @student.pass_hash = md5_hash(@student.dob.to_s)
    persist_success = @student.save
    respond_to do |format|
      if persist_success
        format.html{redirect_to('/student/'+@student.id.to_s+'/edit')}
      else
        format.html{render :action => "student_new"}
      end
    end
    
  end

  def student_edit
    @student = Student.find_by_id(params[:student_id])
  end
  def student_update
    @student = Student.find_by_id(params[:student_id])
    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html{redirect_to('/student/'+@student.id.to_s+'/edit')}
      else
        format.html {render :action => "student_edit"}
      end
    end
    
  end

  def sections_for_batch
    @batch = Batch.find_by_id(params[:batch_id])
    @sections = @batch.sections
    respond_to do |format|
      format.js {render :json => @sections.to_json}
    end
  end

  def teacher_new
    @teacher = Teacher.new
    @teacher.build_address
  end

  def teacher_create
    @institute = Institute.find_by_id(get_institute_id)
    logger.info params.inspect
    @teacher = Teacher.new(params[:teacher])
    @teacher.institute_id = @institute.id
    @teacher.user_type = "CURRENT"
    @teacher.username = create_user_name(@teacher.first_name,@teacher.middle_name,@teacher.last_name)
    @teacher.pass_hash = md5_hash(@teacher.dob.to_s)
    persist_success = @teacher.save
    respond_to do |format|
      if persist_success
        format.html{redirect_to('/teacher/'+@teacher.id.to_s+'/edit')}
      else
        format.html{render :action => "teacher_new"}
      end
    end
  end

  def teacher_edit
    @teacher  = Teacher.find_by_id(params[:teacher_id])
  end

  def teacher_update
    @teacher  = Teacher.find_by_id(params[:teacher_id])
    respond_to do |format|
      if @teacher.update_attributes(params[:teacher])
        format.html{redirect_to('/teacher/'+@teacher.id.to_s+'/edit')}
      else
        format.html {render :action => "teacher_edit"}
        
      end
    end
    
  end

end
