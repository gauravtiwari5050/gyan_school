class SectionController < ApplicationController
  def show
    @section = Section.find_by_id(params[:section_id])
  end
  def attendance_home
    @section = Section.find_by_id(params[:section_id])
  end

  def mark_attendance
    @section = Section.find_by_id(params[:section_id])
    @date = Date.strptime(params[:date],"%Y-%m-%d")
  end
  def mark_attendance_update
    @section = Section.find_by_id(params[:section_id])
    @date = Date.strptime(params[:date],"%Y-%m-%d")
    @institute = Institute.find_by_id(get_institute_id)

    for student in @section.students
      if params.has_key?(student.id.to_s) 
         section_attendance  = SectionAttendance.find(:first,:conditions => {:date => params[:date],:section_id => @section.id,:user_id => student.id})
         if section_attendance.nil?
           section_attendance = SectionAttendance.new
           section_attendance.institute_session_id = get_current_session.id

           section_attendance.section_id = @section.id
           section_attendance.user_id = student.id
           section_attendance.date = params[:date]
           section_attendance.present = true
           section_attendance.save #TODO failure check
         else
            section_attendance.update_attribute(:present ,true)
         end
         
      else
         section_attendance  = SectionAttendance.find(:first,:conditions => {:date => params[:date],:section_id => @section.id,:user_id => student.id})
         if !section_attendance.nil?
          section_attendance.update_attribute(:present ,false)
         else
           section_attendance = SectionAttendance.new
           section_attendance.institute_session_id = get_current_session.id
           section_attendance.section_id = @section.id
           section_attendance.user_id = student.id
           section_attendance.date = params[:date]
           section_attendance.present = false
           section_attendance.save #TODO failure check
         end
      end

    end
    respond_to do |format|
        format.html { redirect_to('/section/' + @section.id.to_s + '/mark_attendance/'+params[:date], :notice => 'Attendance updated') }
    end
    
  end
  
  def exams_index
    @section = Section.find_by_id(params[:section_id])
    @exam = Exam.new
  end

  def exam_new
    @section = Section.find_by_id(params[:section_id])
    @exam = Exam.new
  end

  def exam_create
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

  def exam_subjects
    @institute = Institute.find_by_id(get_institute_id)
    @section = Section.find_by_id(params[:section_id])
    @exam = Exam.find_by_id(params[:exam_id])
  end

  def subjects_new
    @section = Section.find_by_id(params[:section_id])
    @batch = @section.batch
    3.times {@batch.courses.build}
    
  end

  def subjects_update
    @section = Section.find_by_id(params[:section_id])
    @batch = @section.batch
    respond_to do |format|
      if @batch.update_attributes(params[:batch])
        format.html {redirect_to('/section/'+@section.id.to_s+'/subjects')}
      else
        format.html {render :action => "subjects_new"}
        
      end
    end
    
  end

  def subjects_index
    @section = Section.find_by_id(params[:section_id])
    @batch = @section.batch
  end

  def exam_subject_marks
    @institute = Institute.find_by_id(get_institute_id)
    @section = Section.find_by_id(params[:section_id])
    @exam = Exam.find_by_id(params[:exam_id])
    @subject = Course.find_by_id(params[:course_id])
  end

  def attendance_report_show
    @section = Section.find_by_id(params[:section_id])
    section_attendances = SectionAttendance.find(:all,:conditions => {:section_id => @section.id,:date => params[:date]}) 
    user_ids = section_attendances.map(&:user_id)
    @absent_students = []
    @section.students.each do |student|
      if !user_ids.include?(student.id)
        @absent_students << student
      end
    end
  end

  def attendance_report_send
   @section = Section.find_by_id(params[:section_id])
   @task = Task.new
   @task.task_type = "ATTENDANCE_REPORT"
   @task.status = "PENDING"
   @task.institute_id =  get_institute_id

   if !@task.save
    logger.error @task.errors.inspect
    raise 'Error saving task '
   end

   Delayed::Job.enqueue(AttendanceReportJob.new(@section.id,params[:date],@task.id))
   respond_to do |format|
    format.html {redirect_to ('/section/'+@section.id.to_s+'/attendance')}
   end

    
  end

  def exam_reminder_send
   @section = Section.find_by_id(params[:section_id])
   @exam = Exam.find_by_id(params[:exam_id])
   @task = Task.new
   @task.task_type = "EXAM_REMINDER"
   @task.status = "PENDING"
   @task.institute_id =  get_institute_id


   if !@task.save
    logger.error @task.errors.inspect
    raise 'Error saving task '
   end


   Delayed::Job.enqueue(ExamReminderJob.new(@section.id,@exam.id,@task.id))
   respond_to do |format|
    flash[:notice] = "Exam reminder SMS is being sent to parents"
    format.html {redirect_to ('/section/'+@section.id.to_s+'/exams')}
   end

    
  end

  def exam_subject_send_sms
   @section = Section.find_by_id(params[:section_id])
   @exam = Exam.find_by_id(params[:exam_id])
   @subject = Course.find_by_id(params[:course_id])
   @task = Task.new
   @task.task_type = "EXAM_RESULT_NOTIFICATION"
   @task.status = "PENDING"
   @task.institute_id =  get_institute_id
   if !@task.save
    logger.error @task.errors.inspect
    raise 'Error saving task '
   end
   
   Delayed::Job.enqueue(ExamResultNotificationJob.new(@section.id,@exam.id,@subject.id,@task.id))
   respond_to do |format|
    flash[:notice] = "Exam result notification SMSs are being sent to parents"
     format.html {redirect_to('/section/' + @section.id.to_s + '/exams/' + @exam.id.to_s + '/subjects/' + @subject.id.to_s + '/show')} 
   end
    
  end


  def exam_subject_marks_update
    #TODO 1 check for exam result update/save failure and report error in meesage for specific students
    success = true
    @institute = Institute.find_by_id(get_institute_id)
    @section = Section.find_by_id(params[:section_id])
    @exam = Exam.find_by_id(params[:exam_id])
    @subject = Course.find_by_id(params[:course_id])
    logger.info params.inspect
    total_marks = params[:total_marks]
    if total_marks.nil? || total_marks.length == 0
      success = false
      msg = 'Please provide the total marks for this exam'
    end
    if success
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
            exam_result.total = total_marks
            success = exam_result.save #TODO check for failure 
            if !success
                msg = 'Something went wrong while creating the record. Please try again later.'
                logger.error exam_result.errors.inspect 
            end
          else
            success = exam_result.update_attributes(:score => params[student.id.to_s],:total => total_marks)
            if !success
                msg = 'Something went wrong while updating the record. Please try again later.'
                logger.error exam_result.errors.inspect 
            end
          end
        elsif params.has_key?(student.id.to_s) && params[student.id.to_s].size  == 0
          if !exam_result.nil?
            success = exam_result.destroy #check for failure
            if !success
                msg = 'Something went wrong while deleting the record. Please try again later.'
                logger.error exam_result.errors.inspect 
            end
          end
        end
      end
    end


    respond_to do |format|
     if success
      flash[:notice] = 'Marks updated successfuly'
     else
      flash[:alert] = msg
     end
     format.html {redirect_to('/section/' + @section.id.to_s + '/exams/' + @exam.id.to_s + '/subjects/' + @subject.id.to_s + '/show')} 
    end

  end

end
