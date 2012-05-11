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


  def section_show
    @section = Section.find_by_id(params[:section_id])
  end

  def section_attendance_home
    @section = Section.find_by_id(params[:section_id])
  end

  def section_mark_attendance
    @section = Section.find_by_id(params[:section_id])
    @date = Date.strptime(params[:date],"%Y-%m-%d")
  end

  def section_mark_attendance_update
    @section = Section.find_by_id(params[:section_id])
    @date = Date.strptime(params[:date],"%Y-%m-%d")

    for student in @section.students
      if params.has_key?(student.id.to_s) 
         section_attendance  = SectionAttendance.find(:first,:conditions => {:date => params[:date],:section_id => @section.id,:user_id => student.id})
         if section_attendance.nil?
           section_attendance = SectionAttendance.new
           section_attendance.section_id = @section.id
           section_attendance.user_id = student.id
           section_attendance.date = params[:date]
           section_attendance.save #TODO failure check
         end
      else
         section_attendance  = SectionAttendance.find(:first,:conditions => {:date => params[:date],:section_id => @section.id,:user_id => student.id})
         if !section_attendance.nil?
          section_attendance.destroy #failure check
         end
      end

    end
    respond_to do |format|
        format.html { redirect_to('/section/' + @section.id.to_s + '/mark_attendance/'+params[:date], :notice => 'Attendance updated') }
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

  def section_exams_index
    @section = Section.find_by_id(params[:section_id])
    @exam = Exam.new
    
  end

  def section_exams_create
    @section = Section.find_by_id(params[:section_id])
    @exam = Exam.new(params[:exam])
    @exam.examable_type = 'Section'
    @exam.examable_id = @section.id
    persist_success = @exam.save
    respond_to do |format|
      if persist_success
        format.html {redirect_to('/section/' + @section.id.to_s  + '/exams' )}
      else
        format.html {render :action => "section_exams_index"}
      end
    end
    
  end

  def section_exam_subjects
    @institute = Institute.find_by_id(get_institute_id)
    @section = Section.find_by_id(params[:section_id])
    @exam = Exam.find_by_id(params[:exam_id])
    
  end

  def section_exam_subject_marks
    @institute = Institute.find_by_id(get_institute_id)
    @section = Section.find_by_id(params[:section_id])
    @exam = Exam.find_by_id(params[:exam_id])
    @subject = Course.find_by_id(params[:course_id])
  end

  def section_exam_subject_marks_update
    #TODO 1 check for exam result update/save failure and report error in meesage for specific students
    @institute = Institute.find_by_id(get_institute_id)
    @section = Section.find_by_id(params[:section_id])
    @exam = Exam.find_by_id(params[:exam_id])
    @subject = Course.find_by_id(params[:course_id])
    logger.info params.inspect
    for student in @section.students
      exam_result = get_score(@section.id,student.id,@exam.id,@subject.id)
      if params.has_key?(student.id.to_s) && params[student.id.to_s].size  > 0
        logger.info  params[student.id.to_s]
        if exam_result.nil?
          exam_result = ExamResult.new
          exam_result.section_id = @section.id
          exam_result.user_id = student.id
          exam_result.exam_id = @exam.id
          exam_result.course_id = @subject.id
          exam_result.score = params[student.id.to_s]
          exam_result.save #TODO check for failure 
        else
          exam_result.update_attribute(:score,params[student.id.to_s])
        end
      elsif params.has_key?(student.id.to_s) && params[student.id.to_s].size  == 0
        if !exam_result.nil?
          exam_result.destroy #check for failure
        end
      end
    end

    respond_to do |format|
     format.html {redirect_to('/section/' + @section.id.to_s + '/exams/' + @exam.id.to_s + '/subjects/' + @subject.id.to_s + '/show')} 
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

  

end
