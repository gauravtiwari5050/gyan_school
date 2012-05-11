class GettingStartedController < ApplicationController
  def school_info_edit
    @institute = Institute.find_by_id(get_institute_id)
    @structure_info = @institute.structure_info
    if @structure_info.nil?
     @structure_info = StructureInfo.new 
    end
  end

  def school_info_update
    @institute = Institute.find_by_id(get_institute_id)
    @structure_info = @institute.structure_info
    persist_success = false
    if @structure_info.nil?
      @structure_info = StructureInfo.new(params[:structure_info])
      @structure_info.institute_id = @institute.id
      persist_success = @structure_info.save
    else
      persist_success = @structure_info.update_attributes(params[:structure_info])
    end
    if persist_success == true
      #create background task here
      #check here if there is already a pending job then cancel it ,
      #what will happen if the pending job is already underway ?
      Delayed::Job.enqueue(InstituteSetupJob.new(@institute.id))
      if !@institute.setup_info.update_attributes(:status=>'CREATING_STRUCTURE_PROCESSING',:comment => nil)  
        raise 'Error updating setup info'
      end
    end
    respond_to do |format|
      if persist_success
        format.html {redirect_to ('/getting_started/school_information/processing')}
      else
        format.html {render :action => "school_info_edit"}  
      end
    end
    
  end

  def school_info_process
    
  end

  def setup_info
    @institute = Institute.find_by_id(get_institute_id)
    @setup_info = @institute.setup_info
    respond_to do |format|
      format.js {render :json => @setup_info}
    end

  end

  def assign_teachers_edit
    @institute = Institute.find_by_id(get_institute_id)
  end
  def assign_teachers_processing
    @institute = Institute.find_by_id(get_institute_id)
    @institute.setup_info.update_attributes(:status => 'ASSIGN_SUBJECTS' ,:comment => nil)
    respond_to do |format|
      format.html {redirect_to('/getting_started/assign_subjects/edit')}
    end
  end

  def assign_subjects_edit
    @institute = Institute.find_by_id(get_institute_id)
  end
    
  def assign_subjects_update
    logger.info params.inspect
    @institute = Institute.find_by_id(get_institute_id)
    for batch in @institute.batches
      if !params[batch.id.to_s].nil? && params[batch.id.to_s].length > 0
        logger.info 'Crearting subjects for batch ' + batch.name
        subject_ids = params[batch.id.to_s].split(',')
        for subject_id in subject_ids
         subject = DefaultSubject.find_by_id(subject_id) 
         logger.info 'Creating subject ' + subject.name
         course = batch.courses.find_by_name(subject.name)
         if course.nil?
          course = Course.new
          course.batch_id = batch.id
          course.name = subject.name
          course.save
         end
        end
      end
    end

    @institute.setup_info.update_attributes(:status => 'DONE' ,:comment => nil)
    respond_to do |format|
      format.html {redirect_to(get_home_for_user)}
    end
    
  end

    
end
