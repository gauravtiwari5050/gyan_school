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

end
