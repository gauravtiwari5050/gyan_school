class PrintController < ApplicationController
  def student_details
    @students = Institute.find_by_id(get_institute_id).students
    respond_to do |format|
      format.pdf do
        render :pdf => "student_details"
      end
    end
  end
  def teacher_details
    @teachers = Institute.find_by_id(get_institute_id).teachers
    respond_to do |format|
      format.pdf do
        render :pdf => "teacher_details"
      end
    end
  end

  def report_card
    @student = Student.find_by_id(params[:student_id])
    @institute = Institute.find_by_id(get_institute_id)
    respond_to do |format|
      format.pdf do
        render :pdf => "report_card"
      end
    end
  end
end
