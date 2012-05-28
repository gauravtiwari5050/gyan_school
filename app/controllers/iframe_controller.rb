class IframeController < ApplicationController
  def change_picture
    @student = Student.find_by_id(params[:student_id])   
    @profile = Profile.new
  end
end
