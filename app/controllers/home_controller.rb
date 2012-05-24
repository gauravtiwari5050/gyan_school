include Util
class HomeController < ApplicationController
  before_filter :setup_redirect
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
    @display_title = "Create new class/batch and sections"
    3.times {@batch.sections.build}
  end

  def batch_create
    logger.info params.inspect
    @batch = Batch.new(params[:batch])
    @batch.institute_id = get_institute_id
    persist_success = @batch.save
    respond_to do |format|
    if persist_success
      format.html {redirect_to("/classes")}
    else
      format.html {render :action => "batch_new"}
    end
    end
  end

  def batch_edit
    @institute = Institute.find_by_id(get_institute_id)
    @batch = Batch.find_by_id(params[:batch_id])
    @display_title = "Edit batch/create or remove sections"
    respond_to do |format|
      format.html {render :action => "batch_new"}
    end
  end

  def batch_show
    @institute = Institute.find_by_id(get_institute_id)
    @batch = Batch.find_by_id(params[:batch_id])
  end

  def batch_index
    @institute = Institute.find_by_id(get_institute_id)
  end

  def batch_update
    @institute = Institute.find_by_id(get_institute_id)
    @batch = Batch.find_by_id(params[:batch_id])
    respond_to do |format|
      if @batch.update_attributes(params[:batch])
        format.html {redirect_to('/batch/'+@batch.id.to_s+'/show')}
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

  def student_search
    
  end

  def teacher_search
    
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

  def subjects_show
    @institute = Institute.find_by_id(get_institute_id)
    if @institute.courses.size == 0
      logger.info 'building new courses'
      3.times{@institute.courses.build} 
    end
  end

  def subjects_create
    @institute = Institute.find_by_id(get_institute_id)
    respond_to do |format|
      if @institute.update_attributes(params[:institute])
        format.html {redirect_to('/subjects/show')}
      else
        format.html {render :action => "subjects_show"}
      end
    end
    
  end






  def fees_schedule_index
    @institute = Institute.find_by_id(get_institute_id)
    
  end

  def fees_schedule_new
    @institute = Institute.find_by_id(get_institute_id)
    @fee_collection_event  = FeeCollectionEvent.new
    
  end

  def fees_schedule_create
    @institute = Institute.find_by_id(get_institute_id)
    @fee_collection_event  = FeeCollectionEvent.new(params[:fee_collection_event])
    @fee_collection_event.institute_id = @institute.id
    respond_to do |format|
      if @fee_collection_event.save 
        format.html {redirect_to('/fees/schedule_index')}
      else
       format.html {render :action => 'fees_schedule_new'}
      end

    end
    
  end
  def fees_schedule_update
    @institute = Institute.find_by_id(get_institute_id)
    @fee_collection_event  = FeeCollectionEvent.find_by_id(params[:fee_event_id])
    respond_to do |format|
      if @fee_collection_event.update_attributes(params[:fee_collection_event]) 
        format.html {redirect_to('/fees/schedule_index')}
      else
       format.html {render :action => 'fees_schedule_edit'}
      end

    end
    
  end


  def fees_schedule_edit
    @institute = Institute.find_by_id(get_institute_id)
    @fee_collection_event  = FeeCollectionEvent.find_by_id(params[:fee_event_id])
  end

  def fees_collect
    @institute = Institute.find_by_id(get_institute_id)

  end

  def search_students
    @users = []
    if !(params[:username].nil? || params[:username].size == 0)
      @users = Student.find(:all,:conditions =>['first_name like ? and institute_id = ?' , params[:username]+'%',get_institute_id])
    end
    respond_to do |format|
      format.js  { render :json => @users.to_json }
    end
  end
  def search_teachers
    @users = []
    if !(params[:username].nil? || params[:username].size == 0)
      @users = Teacher.find(:all,:conditions =>['first_name like ? and institute_id = ?' , params[:username]+'%',get_institute_id])
    end
    respond_to do |format|
      format.js  { render :json => @users.to_json }
    end
  end

  def fees_collect_student
    @institute = Institute.find_by_id(get_institute_id)
    @student = Student.find_by_id(params[:student_id])
  end

  def fees_collect_student_update
    @institute = Institute.find_by_id(get_institute_id)
    @student = Student.find_by_id(params[:student_id])
    logger.info params[:inspect]
    for event in @institute.fee_collection_events
        fee_collection = FeeCollection.find(:first,:conditions => {:user_id=>@student.id,:fee_collection_event_id=>event.id} )
      if params.has_key?(event.id.to_s) && fee_collection.nil?
        fee_collection =  FeeCollection.new
        fee_collection.user_id = @student.id
        fee_collection.fee_collection_event_id = event.id
        if !fee_collection.save
          raise 'Error saving fee collection while updating fees details'
        end
      elsif !params.has_key?(event.id.to_s) && !fee_collection.nil?
        if !fee_collection.destroy
          raise 'Error saving fee collection while updating fees details'
        end
      end
      
    end

    respond_to do |format|
        format.html { redirect_to('/fees/collect/' + @student.id.to_s, :notice => 'Fees record updated') }
    end
  end






  def setup_redirect
    if current_user.type == 'Admin'
      
      institute = Institute.find_by_id(get_institute_id)
      logger.info 'setup_status is' + institute.setup_info.status
      
      if institute.setup_info.status.start_with? 'CREATING_STRUCTURE'
        redirect_to( '/getting_started/school_information/edit')
      elsif institute.setup_info.status.start_with? 'ASSIGN_TEACHERS'
        redirect_to ('/getting_started/assign_teachers/edit')
      elsif institute.setup_info.status.start_with? 'ASSIGN_SUBJECTS'
        redirect_to( '/getting_started/assign_subjects/edit')
      end
    end
  end

  ## dashboard urls
  def students_index
   @students = Institute.find_by_id(get_institute_id).students 
  end

  def teachers_index
   @teachers = Institute.find_by_id(get_institute_id).teachers 
  end

  def students_upload_file
    @helper_file =  HelperFile.new
    @task = Task.find(:first,:conditions => {:institute_id => get_institute_id,:task_type => 'UPLOAD_FILE_STUDENTS'})
    @success_message = ''
    @failure_message = ''
    if !@task.nil?
      if @task.status == 'SUCCESS'
        @success_message = @task.comment.to_s
        @task.destroy
        @task = nil
      elsif @task.status == 'FAILURE'
       logger.error 'Task failure message ' + @task.comment
        @failure_message = @task.comment.to_s
        @task.destroy
        @task = nil
      end
    end
  end
  def teachers_upload_file
    @helper_file =  HelperFile.new
    @task = Task.find(:first,:conditions => {:institute_id => get_institute_id,:task_type => 'UPLOAD_FILE_TEACHERS'})
    @success_message = ''
    @failure_message = ''
    if !@task.nil?
      if @task.status == 'SUCCESS'
        @success_message = @task.comment.to_s
        @task.destroy
        @task = nil
      elsif @task.status == 'FAILURE'
       logger.error 'Task failure message ' + @task.comment
        @failure_message = @task.comment.to_s
        @task.destroy
        @task = nil
      end
    end
  end

  def students_upload_file_create
    #TODO this needs to be moved to an s3 based service
    @helper_file = HelperFile.new(params[:helper_file])
    @helper_file.institute_id = get_institute_id
    persist_success = @helper_file.save
    if persist_success == true
       task = Task.find(:first,:conditions => {:institute_id => get_institute_id,:task_type => 'UPLOAD_FILE_STUDENTS'})
       if task.nil?
         task  =  Task.new
        task.task_type = 'UPLOAD_FILE_STUDENTS'
        task.status = 'PENDING'
        task.comment = ''
        task.institute_id =  get_institute_id
        persist_success = task.save
        if !persist_success
          raise 'Error saving task object'
        end
      else
        persist_success = task.update_attributes(:status => 'PENDING',:comment => '')
        if !persist_success
          raise 'Error saving task object'
        end
      end

    end
    respond_to do |format|
      if persist_success == true
        Delayed::Job.enqueue(CreateStudentsFromFileJob.new(@helper_file.id,task.id))
        format.html {redirect_to('/students/upload_file/new')}
      else
        format.html {render :action => 'students_upload_file'}
      end
    end
  end


  def teachers_upload_file_create
    #TODO this needs to be moved to an s3 based service
    @helper_file = HelperFile.new(params[:helper_file])
    @helper_file.institute_id = get_institute_id
    persist_success = @helper_file.save
    if persist_success == true
       task = Task.find(:first,:conditions => {:institute_id => get_institute_id,:task_type => 'UPLOAD_FILE_TEACHERS'})
       if task.nil?
         task  =  Task.new
        task.task_type = 'UPLOAD_FILE_TEACHERS'
        task.status = 'PENDING'
        task.comment = ''
        task.institute_id =  get_institute_id
        persist_success = task.save
        if !persist_success
          raise 'Error saving task object'
        end
      else
        persist_success = task.update_attributes(:status => 'PENDING',:comment => '')
        if !persist_success
          raise 'Error saving task object'
        end
      end

    end
    respond_to do |format|
      if persist_success == true
        Delayed::Job.enqueue(CreateTeachersFromFileJob.new(@helper_file.id,task.id))
        format.html {redirect_to('/teachers/upload_file/new')}
      else
        format.html {render :action => 'teachers_upload_file'}
      end
    end
  end

  def classes_index
    @institute = Institute.find_by_id(get_institute_id)
    @batches = @institute.batches
  end

  def fees_reminder
    @institute = Institute.find_by_id(get_institute_id)
    @fee_collection_event  = FeeCollectionEvent.find_by_id(params[:fee_event_id])
    @task = Task.new
    @task.task_type = "FEES_REMINDER"
    @task.status = "PENDING"
    @task.institute_id =  get_institute_id
    if !@task.save
      logger.error @task.errors.inspect
     raise 'Error saving task '
    end
   Delayed::Job.enqueue(FeesReminderJob.new(@fee_collection_event.id,@institute.id,@task.id))
   
   respond_to do |format|
    flash[:notice] = "Fees Reminders are being sent to parents"
    format.html {redirect_to('/fees/schedule_index')}
   end
    
    
  end

  def whitelist_numbers
    @institute = Institute.find_by_id(get_institute_id)
    @telephone_whitelist = TelephoneWhitelist.new
  end

  def whitelist_numbers_update
    @telephone_whitelist = TelephoneWhitelist.new(params[:telephone_whitelist])
    respond_to do |format|
      if @telephone_whitelist.save
        flash[:notice] = 'Number whitelisted'
        format.html {redirect_to('/whitelist/show')}
      else
        format.html {render :action => 'whitelist_numbers'}
      end
    end
  end

  def whitelist_number_delete
    @telephone_whitelist = TelephoneWhitelist.find_by_id(params[:id])
    @telephone_whitelist.destroy
    respond_to do |format|
        flash[:notice] = 'Number delisted'
        format.html {redirect_to('/whitelist/show')}
    end


  end

  def upload_video_new
    @helper_file = HelperFile.new
  end

  def upload_video_create
    @helper_file = HelperFile.new(params[:helper_file])
    respond_to do |format|
      if @helper_file.save
        flash[:notice] = 'Queued for processing'
        Delayed::Job.enqueue(CreateVideoContentsFromFileJob.new(@helper_file.id))
      else
        flash[:alert] = 'Errored'
      end
      format.html{redirect_to('/upload_video/new')}
    end
    
  end

  def video_search

  logger.info params.inspect
    search_term = ''
    if params[:query].nil?
      search_term = 'math'
    else
      search_term = params[:query]
    end

    @search = EduVideo.search do
      fulltext search_term
    end

    @videos = @search.results
    logger.info @videos.length 
  end
  

end
