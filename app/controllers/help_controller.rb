class HelpController < ApplicationController
  def home
    
  end

  def topics
    @help_topic = HelpTopic.new  
  end

  def topic_create
    @help_topic = HelpTopic.new(params[:help_topic])
    respond_to do |format|
      if @help_topic.save
      format.html {redirect_to('/help/topics/list')}
      else
      format.html {render :action => 'topics'}
      end
    end
  end

  def topic_edit
    @help_topic = HelpTopic.find_by_id(params[:topic_id])
    3.times{@help_topic.help_subtopics.build}
    
  end

  def topic_update
    @help_topic = HelpTopic.find_by_id(params[:topic_id])
    persist_success = @help_topic.update_attributes(params[:help_topic])
    respond_to do |format|
      if persist_success
      format.html {redirect_to('/help/topics/list')}
      else
      format.html {render :action => 'topic_edit'}
      end
    end
  end
  def topic_show
    @help_topic = HelpTopic.find_by_id(params[:topic_id])
  end

  def subtopic_edit
    @sub_topic = HelpSubtopic.find_by_id(params[:subtopic_id])
    3.times{@sub_topic.help_steps.build}
  end


  def subtopic_update
    logger.info params.inspect
    @sub_topic = HelpSubtopic.find_by_id(params[:subtopic_id])
    persist_success = @sub_topic.update_attributes(params[:sub_topic])
    respond_to do |format|
      if persist_success
      format.html {redirect_to('/help/subtopics/'+@sub_topic.id.to_s+'/edit')}
      else
      format.html {render :action => 'subtopic_edit'}
      end
    end
  end

end
