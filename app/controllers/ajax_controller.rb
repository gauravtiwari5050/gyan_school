class AjaxController < ApplicationController
  def section_update_teacher
    logger.info params.inspect
    @section = Section.find_by_id(params[:section_id])
    @teacher = Teacher.find_by_id(params[:teacher_id])
    persist_success = false
    teacher_section =  TeacherSection.find(:first,:conditions => {:section_id => @section.id,:institute_id => get_institute_id})
    if teacher_section.nil?
      teacher_section = TeacherSection.new
      teacher_section.institute_id = get_institute_id
      teacher_section.section_id = @section.id
      teacher_section.user_id = @teacher.id
      persist_success = teacher_section.save
    else
      persist_success = teacher_section.update_attribute(:user_id,@teacher.id) 
    end
    
    respond_to do |format|
     if persist_success
      format.js {render :json => @teacher}
     else
      format.js {render :json => @teacher}
      #logger.error teacher_section.errors.inspect
      #raise 'Error updating teacher'

     end
    end
  end
  def default_subjects
   @default_subjects = DefaultSubject.where('name like ?',"%#{params[:q]}%") 
    respond_to do |format|
      format.js {render :json => @default_subjects.to_json}
    end
  end

  def task_status
    @task = Task.find(:first,:conditions => {:id =>params[:task_id]}) 
    if @task.nil?
      @task = Task.new
      @task.status = 'FAILURE'
    end
    respond_to do |format|
      format.js {render :json => @task.to_json}
    end
  end
  def institute_attendance_report
   absent = SectionAttendance.count(:all,:conditions => {:institute_session_id => get_current_session.id,:present => false})
   present = SectionAttendance.count(:all,:conditions => {:institute_session_id => get_current_session.id,:present => true})
   logger.info 'Present ' + present.to_s
   logger.info 'Absent ' + absent.to_s
   attendance = Hash.new
   attendance["Present"] = present
   attendance["Absent"] = absent

   respond_to do |format|
    format.js {render :json => attendance.to_json} 
   end
  end
  def section_attendance_report
   section = Section.find_by_id(params[:section_id])
   if section.nil?
    raise 'Section not found'
   end
   absent = SectionAttendance.count(:all,:conditions => {:institute_session_id => get_current_session.id,:present => false,:section_id => section.id})
   present = SectionAttendance.count(:all,:conditions => {:institute_session_id => get_current_session.id,:present => true,:section_id => section.id})
   logger.info 'Present ' + present.to_s
   logger.info 'Absent ' + absent.to_s
   attendance = Hash.new
   attendance["Present"] = present
   attendance["Absent"] = absent

   respond_to do |format|
    format.js {render :json => attendance.to_json} 
   end
  end

  def institute_performance_report
    report = Hash.new
    report["A"] = 0
    report["B"] = 0
    report["C"] = 0
    report["D"] = 0
    report["E"] = 0
    institute = Institute.find_by_id(get_institute_id)
    institute.batches.each do |batch|
      batch.sections.each do |section|
        section.exam_results.each do |result|
          percentage = (result.score * 100)/(result.total)
          if percentage > 90
            report["A"] +=1
          elsif percentage > 80
            report["B"] +=1
          elsif percentage > 60
            report["C"] +=1
          elsif percentage > 40
            report["D"] +=1
          else
            report["E"] +=1
          end

        end
      end
    end

      respond_to do |format|
        format.js {render :json => report.to_json} 
      end
    
  end
  
  def section_performance_report
    report = Hash.new
    report["A"] = 0
    report["B"] = 0
    report["C"] = 0
    report["D"] = 0
    report["E"] = 0
    section = Section.find_by_id(params[:section_id])
        section.exam_results.each do |result|
          percentage = (result.score * 100)/(result.total)
          if percentage > 90
            report["A"] +=1
          elsif percentage > 80
            report["B"] +=1
          elsif percentage > 60
            report["C"] +=1
          elsif percentage > 40
            report["D"] +=1
          else
            report["E"] +=1
          end

        end

      respond_to do |format|
        format.js {render :json => report.to_json} 
      end
    
  end

  def institute_fees_report
    institute = Institute.find_by_id(get_institute_id)
    logger.info 'Current institute_id '  + institute.id.to_s
    number_of_students = institute.students.size
    logger.info 'Current number of stundents '  + number_of_students.to_s
    report = Hash.new
    institute.fee_collection_events.each do |event|
      month = event.due_date.strftime("%B")
      if report[month].nil?
        report[month]  = {}
        report[month][:paid] = 0
        report[month][:not_paid] = 0
      end
      report[month][:paid] += event.fee_collections.size
      report[month][:not_paid] = (number_of_students - report[month][:paid])

    end


      respond_to do |format|
        format.js {render :json => report.to_json} 
      end

  end

  def section_fees_report
    institute = Institute.find_by_id(get_institute_id)
    section = Section.find_by_id(params[:section_id])
    logger.info 'Current institute_id '  + institute.id.to_s
    report = Hash.new
    institute.fee_collection_events.each do |event|
      month = event.due_date.strftime("%B")
      if report[month].nil?
        report[month]  = {}
        report[month][:paid] = 0
        report[month][:not_paid] = 0
      end
      event.fee_collections.each do |collection|
        if collection.user.section.id == section.id
          report[month][:paid] += 1;
        end
      end
      number_of_students = section.students.size
      report[month][:not_paid] = (number_of_students - report[month][:paid])

    end


      respond_to do |format|
        format.js {render :json => report.to_json} 
      end

  end

  def delete_section
      section = Section.find_by_id(params[:section_id])
      section_delete(section)  
      respond_to do |format|
        format.js {render :json => nil} 
      end
    
  end

  def delete_batch
    batch = Batch.find_by_id(params[:batch_id])
    batch.sections.each do |section|
      section_delete(section)
    end
    batch.destroy
      respond_to do |format|
        format.js {render :json => nil} 
      end
  end

  def student_attendance_report
    attendances = SectionAttendance.find(:all,:conditions => {:user_id => params[:student_id],:institute_session_id => get_current_session.id})
    report = []
    attendances.each do |attendance|
      obj = Hash.new
      obj["id"] = attendance.id
      if attendance.present == true
        obj["title"] = "Present"
        obj["color"] = 'green'
        obj["textColor"] = 'white'
      else
        obj["title"] = "Absent"
        obj["color"] = 'red'
        obj["textColor"] = 'white'
      end
      obj["allDay"] = true
      obj["start"] = attendance.date.rfc822
      report.push(obj)
    end
      respond_to do |format|
        format.js {render :json => report.to_json} 
      end
  end




end
