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

end
