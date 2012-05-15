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
end