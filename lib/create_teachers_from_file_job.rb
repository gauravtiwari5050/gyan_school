include Util
class CreateTeachersFromFileJob < Struct.new(:helper_file_id,:task_id)
  def perform
    process_success = true
    msg = ''
    Delayed::Worker.logger.info 'Helper File Id ' + helper_file_id.to_s
    Delayed::Worker.logger.info 'Task Id ' + task_id.to_s
    task = Task.find_by_id(task_id)
    helper_file = HelperFile.find_by_id(helper_file_id)
    institute = helper_file.institute
    Delayed::Worker.logger.info 'Helper File current path' + helper_file.name.current_path.to_s
    teachers_list = Spreadsheet.open helper_file.name.current_path
    begin
        for worksheet in teachers_list.worksheets
          worksheet.each do |row|
            if row.length > 0
              if row.length != 5
                msg = 'The teachers file is of invalid format. Please try again'
                raise 'Invalid File Format'
              end
              teacher = Teacher.new
              teacher.first_name = row[0]
              teacher.middle_name = row[1]
              teacher.last_name = row[2]
              teacher.email = row[3]
              teacher.username = 'dummy'
              teacher.user_type = 'CURRENT'
              teacher.pass_hash = md5_hash('teacher123')
              teacher.institute_id = institute.id
              if !teacher.save
                msg = 'Error saving teacher information with details' 
                msg += '(First Name : ' + teacher.first_name  + ', '
                msg += 'Middle Name : ' + teacher.middle_name + ', '
                msg += 'Last Name : ' + teacher.last_name + ', '
                msg += 'Email : ' + teacher.email + ', '
                msg += 'Please make sure the email is unique and phone is of 10 digits '
                raise teacher.errors.inspect
              end
            end
          end
        end
      
    rescue Exception => e
      Delayed::Worker.logger.info e.message
      process_success = false
      msg = 'An error occured ' + msg
    end
    if process_success == false
      task.update_attributes(:status => 'FAILURE',:comment => msg) #TODO check failure here
    else
      task.update_attributes(:status => 'SUCCESS',:comment => 'Teachers created successfully.') #TODO check failure here
    end
    helper_file.destroy

  end
end
