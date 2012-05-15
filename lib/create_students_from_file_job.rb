include Util
class CreateStudentsFromFileJob < Struct.new(:helper_file_id,:task_id)
  def perform
    process_success = true
    msg = ''
    Delayed::Worker.logger.info 'Helper File Id ' + helper_file_id.to_s
    Delayed::Worker.logger.info 'Task Id ' + task_id.to_s
    task = Task.find_by_id(task_id)
    helper_file = HelperFile.find_by_id(helper_file_id)
    institute = helper_file.institute
    Delayed::Worker.logger.info 'Helper File current path' + helper_file.name.current_path.to_s
    students_list = Spreadsheet.open helper_file.name.current_path
    begin
      ActiveRecord::Base.transaction do
        for worksheet in students_list.worksheets
          worksheet.each do |row|
            if row.length > 0
              if row.length != 9
                msg = 'The students file is of invalid format. Please try again'
                raise 'Invalid Student File Format'
              end
              student = Student.new
              student.first_name = row[0]
              student.middle_name = row[1]
              student.last_name = row[2]
              student.dob = row[3]
              student.username = 'dummy'
              student.user_type = 'CURRENT'
              student.pass_hash = md5_hash('student123')
              student.institute_id = institute.id #TODO not good pass institute id directly
              batch_name = row[7]
              section_name = row[8]
              batch = institute.batches.find(:first,:conditions => {:name => batch_name})
              if batch.nil?
                batch = Batch.new
                batch.institute_id = institute.id
                batch.name = batch_name
                if !batch.save
                  msg = 'Error creating class level ' +  batch.name + '. Please try again.'
                  raise 'Error saving batch information while creating student object'
                end
              end
              section = batch.sections.find(:first,:conditions => {:name => section_name})
              if section.nil?
                section = Section.new
                section.batch_id = batch.id
                section.name = section_name
                if !section.save
                  msg = 'Error creating section for class level ' +  batch.name + '. Please try again.'
                  raise 'Error saving batch section information while creating student object'
                end
              end

              student.section_id = section.id

              if !student.save
                  msg = 'Error saving student  information with details' 
                  msg += '(First Name : ' + student.first_name  + ', '
                  msg += 'Middle Name : ' + student.middle_name + ', '
                  msg += 'Last Name : ' + student.last_name + ', '
                  msg += 'DOB : ' + student.dob + ', '
                  msg += 'Phone : ' + row[4] + '). Please make sure the you have provided dob and phone is of 10 digits '
                  raise 'Error saving student information' + student.errors.inspect
              end
              parent_detail = ParentDetail.new
              parent_detail.user_id = student.id
              parent_detail.name = row[5]
              parent_detail.mobile = row[6]
              if !parent_detail.save
                  msg = 'Error saving parent  information with details'
                  msg+= '(Name : ' + parent_detail.name + ', '
                  msg+= 'Mobile: ' + parent_detail.mobile + ') . Please make sure you provide a parent name and mobile of 10 digits'

                  raise 'Error saving parent detail information while creating student object'
              end
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
      task.update_attributes(:status => 'SUCCESS',:comment => 'Students created successfully.') #TODO check failure here
    end
    helper_file.destroy

  end
end
