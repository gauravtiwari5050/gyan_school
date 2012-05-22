require 'net/http'
module Util

  def unique_id(prefix)
  require 'uuidtools'
    return  prefix.to_s + UUIDTools::UUID.timestamp_create.to_s
  end
  
  def md5_hash(content)
  require 'digest/md5'
    digest = Digest::MD5.hexdigest(content) 
    return digest
  end

  def get_class_name_from_index(index)
    h = Hash.new
    h[-3] = "Pre Nursery"; 
    h[-2] = "Nursery"; 
    h[-1] = "Lower KG"; 
    h[0] = "Upper KG"; 
    h[1] = "Standard I"; 
    h[2] = "Standard II"; 
    h[3] = "Standard III"; 
    h[4] = "Standard IV"; 
    h[5] = "Standard V"; 
    h[6] = "Standard VI"; 
    h[7] = "Standard VII"; 
    h[8] = "Standard VIII"; 
    h[9] = "Standard IX"; 
    h[10] = "Standard X"; 
    h[11] = "Standard XI"; 
    h[12] = "Standard XII"; 
    return h[index]
  end

  def send_absent_sms(student,date)
   if student.nil?
    return
   end


    message = "Please note that your ward #{student.first_name} has not come to school on #{date}. Kindly call up the school ( Ph no: ) and inform us the reason."

    send_sms(student.parent_detail.mobile,message)


  end

  def send_sms(mobile_number,message)
    ##check if number is white listed
    whitelisted_number = TelephoneWhitelist.find(:first,:conditions => {:number => mobile_number})
    if whitelisted_number.nil?
      Delayed::Worker.logger.info 'Number not whitelisted not sendig sms'
      return
    end
    user = GyanSchool::Application.config.sms_user
    pass = GyanSchool::Application.config.sms_pass
    sender_id = GyanSchool::Application.config.sms_sender_id
    
    url = "http://203.122.58.168/prepaidgetbroadcast/PrepaidGetBroadcast?userid=#{user}&pwd=#{pass}&msgtype=s&ctype=1&sender=#{sender_id}&pno=91#{mobile_number}&msgtxt=#{message}&alert=1"
    url = URI.escape(url)
    Delayed::Worker.logger.info 'sending ' + url
    req = Net::HTTP.get_response(URI.parse(url))
    Delayed::Worker.logger.info 'response for message sending'
    Delayed::Worker.logger.info 'REQ.status ' + req.inspect.to_s
    Delayed::Worker.logger.info 'REQ.body ' + req.body.to_s
    
  end

  def send_exam_reminder(student,exam)
    if student.nil? || exam.nil?
      return
    end
    message = "Please note that the  #{exam.name} for your ward are going to start from #{exam.start.strftime("%B %d, %Y")}"
    send_sms(student.parent_detail.mobile,message)
  end

  def send_result_notification_sms(student,subject)
    if student.nil? || subject.nil?
      return
    end
   message = "Please note that the  answer papers  for #{subject.name} have been provided to the ward"  
    send_sms(student.parent_detail.mobile,message)
   
  end

  def send_fees_reminder(student,fee_collection_event)
    if student.nil? || fee_collection_event.nil?
      return
    end

    message = "Please note that a fee payment for your  ward #{student.first_name}   towards #{fee_collection_event.due_date.strftime('%B')} is pending"

    send_sms(student.parent_detail.mobile,message)

  end

end
