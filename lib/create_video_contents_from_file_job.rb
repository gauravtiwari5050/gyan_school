class CreateVideoContentsFromFileJob < Struct.new(:file_id)
  def perform
    success =  true
    file_loaded = HelperFile.find_by_id(file_id)
    
    if file_loaded.nil?
      Delayed::Worker.logger.info 'No such file ,nothing to do' 
      return
    end
    file_url = file_loaded.name.current_path
    Delayed::Worker.logger.info 'Creating video content from  : ' + file_url 
    begin
    file = File.new(file_url,"r")
    while (line = file.gets)
      Delayed::Worker.logger.info line
      contents = line.split(",")
      video = EduVideo.new
      video.subject = contents[0]
      video.topic = contents[1]
      video.subtopic = contents[2]
      video.description = contents[3]
      video.url = contents[4]
      video.save
    end
    file.close

    rescue Exception => e
      success = false 
      Delayed::Worker.logger.info e.message
      Delayed::Worker.logger.info e.backtrace.inspect
    end

    Delayed::Job.enqueue(ObjectDestroyJob.new(file_loaded.class.to_s,file_loaded.id),:run_at => 30.seconds.from_now)
    
  end
end
