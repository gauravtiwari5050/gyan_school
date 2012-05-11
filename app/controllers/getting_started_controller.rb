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
end
