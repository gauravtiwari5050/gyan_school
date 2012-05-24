
require 'rubygems'
require 'spreadsheet'
require 'resolv'
include Util

class InstituteSetupJob < Struct.new(:institute_id)
  def perform
    setup_success = true
    msg = ''
    Delayed::Worker.logger.info 'Setting up institute for institute : ' + institute_id.to_s
    institute = Institute.find_by_id(institute_id)
    teachers_list_url = institute.structure_info.teachers_list
    Delayed::Worker.logger.info "Teachers List at" + teachers_list_url.current_path
    teachers_list = Spreadsheet.open teachers_list_url.current_path
    students_list_url = institute.structure_info.students_list
    Delayed::Worker.logger.info "Students List at" + students_list_url.current_path
    students_list = Spreadsheet.open students_list_url.current_path
    begin
      ActiveRecord::Base.transaction do
        if institute.structure_info.start_class >= institute.structure_info.end_class
          msg = 'Starting Class cannot be greater than ending class. Please try again'
          raise 'Invalid Class organization'
        else
          (institute.structure_info.start_class .. institute.structure_info.end_class).each do |index|
            batch = Batch.new
            batch.institute_id = institute.id
            batch.name = get_class_name_from_index(index)
            if !batch.save
              msg = 'Error creating class level ' +  batch.name + '. Please try again.'
              raise 'Error Saving batch information' + batch.errors.inspect
            end
            (1 .. institute.structure_info.max_section).each do |section_index|
              section = Section.new
              section.name = '' + (section_index+64).chr 
              section.batch_id = batch.id
              if !section.save
               msg = 'Error creating section for class level ' +  batch.name + '. Please try again.'
               raise 'Error Saving section information' + section.errors.inspect
              end
            end
            
          end
        end
        for worksheet in teachers_list.worksheets
          worksheet.each_with_index do |row|
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
                msg += 'Phone : ' + row[4] + '). Please make sure the email is unique and phone is of 10 digits '
                raise teacher.errors.inspect
              end
            end
          end
        end

        for worksheet in students_list.worksheets
          worksheet.each_with_index do |row,i|
            if row.length > 0
              if row.length != 9
                msg = 'The students file is of invalid format. Please check row ' + i.to_s + ' and try again'
                Delayed::Worker.logger.info 'Row length for students file is ' + row.length.to_s
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
              student.institute_id = institute.id
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
      setup_success = false
    end
    if setup_success == false
      institute.setup_info.update_attributes(:status => 'CREATING_STRUCTURE',:comment => msg) #TODO check failure here
    else
      institute.setup_info.update_attributes(:status => 'ASSIGN_TEACHERS',:comment => nil) #TODO check failure here
    end
  end

end
