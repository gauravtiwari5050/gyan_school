GyanSchool::Application.routes.draw do
  match "/" => 'static#welcome'
  match "demo" => 'static#demo'
  match "terms" => 'static#terms'
  match "privacy" => 'static#privacy'
  match "about" => 'static#about'
  match "contact" => 'static#contact'
  match '/signup' => 'signup#signup'
  match '/institute/create' => 'signup#register' ,:via => :post
  match 'login' => 'login#login'
  match 'logout' => 'login#destroy'
  match 'login/school' => 'login#login_employee' ,:via => :post
  match 'login/student' => 'login#login_student' ,:via => :post
  match 'home' => 'home#home'
  match 'session/new' => 'home#session_new'
  match 'session/:session_id/edit' => 'home#session_edit'
  match 'session/:session_id/update' => 'home#session_update',:via =>:post
  match 'session/:session_id/delete' => 'home#session_delete'
  match 'sessions/index' => 'home#session_index'
  match 'session/create' => 'home#session_create' ,:via => :post
  match 'batch/new' => 'home#batch_new'
  match 'batch/create' => 'home#batch_create',:via => :post
  match 'batch/index' => 'home#classes_index'
  match 'batch/:batch_id/edit' => 'home#batch_edit'
  match 'batch/:batch_id/show' => 'home#batch_show'
  match 'batch/:batch_id/create' => 'home#batch_update'
  match 'batch/sections/:batch_id' => 'home#sections_for_batch'
  match 'student/new' => 'home#student_new'
  match 'student/search' => 'home#student_search'
  match 'student/:student_id/edit' => 'home#student_edit'
  match 'student/:student_id/create' => 'home#student_update' ,:via => :post
  match 'student/create' => 'home#student_create' ,:via => :post
  match 'teacher/new' => 'home#teacher_new'
  match 'teacher/:teacher_id/edit' => 'home#teacher_edit'
  match 'teacher/:teacher_id/create' => 'home#teacher_update'
  match 'teacher/create' => 'home#teacher_create' ,:via => :post
  match 'teacher/search' => 'home#teacher_search'

  match 'subjects/show' => 'home#subjects_show'
  match 'subjects/create' => 'home#subjects_create'

  match 'section/:section_id/show' => 'section#show'
  match 'section/:section_id/delete' => 'section#show'
  match 'section/:section_id/attendance' => 'section#attendance_home'
  match 'section/:section_id/mark_attendance/:date' => 'section#mark_attendance'
  match 'section/:section_id/mark_attendance/:date/update' => 'section#mark_attendance_update' ,:via => :post
  match 'section/:section_id/exams/create' => 'section#exam_create' ,:via => :post
  match 'section/:section_id/exams/new' => 'section#exam_new'
  match 'section/:section_id/exams' => 'section#exams_index'
  match 'section/:section_id/exams/:exam_id/subjects' => 'section#exam_subjects'
  match 'section/:section_id/exams/:exam_id/subjects/:course_id/sms/send' => 'section#exam_subject_send_sms'
  match 'section/:section_id/exams/:exam_id/subjects/:course_id/show' => 'section#exam_subject_marks'
  match 'section/:section_id/exams/:exam_id/subjects/:course_id/update' => 'section#exam_subject_marks_update'
  match 'section/:section_id/reports/attendance/:date' => 'section#attendance_report_show'
  match 'section/:section_id/reports/attendance/:date/send' => 'section#attendance_report_send'
  match 'section/:section_id/exams/:exam_id/reminder/send' => 'section#exam_reminder_send'
  
  match 'section/:section_id/subjects/new' => 'section#subjects_new'
  match 'section/:section_id/subjects/update' => 'section#subjects_update'
  match 'section/:section_id/subjects' => 'section#subjects_index'

  match 'fees/schedule_index' => 'home#fees_schedule_index'
  match 'fees/schedule/:fee_event_id/reminder/send' => 'home#fees_reminder'
  match 'fees/schedule/:fee_event_id/edit' => 'home#fees_schedule_edit'
  match 'fees/schedule/:fee_event_id/create' => 'home#fees_schedule_update'
  match 'fees/schedule/new' => 'home#fees_schedule_new'
  match 'fees/schedule/create' => 'home#fees_schedule_create' ,:via => :post
  match 'fees/collect' => 'home#fees_collect' 
  match 'search/students' => 'home#search_students' 
  match 'search/teachers' => 'home#search_teachers' 
  match 'fees/collect/:student_id' => 'home#fees_collect_student'
  match 'fees/collect/:student_id/update' => 'home#fees_collect_student_update' ,:via => :post


  match 'getting_started/school_information/edit' => 'getting_started#school_info_edit'
  match 'getting_started/school_information/update' => 'getting_started#school_info_update'
  match 'getting_started/school_information/processing' => 'getting_started#school_info_process'
  match 'getting_started/assign_teachers/edit' => 'getting_started#assign_teachers_edit'
  match 'getting_started/assign_teachers/processing' => 'getting_started#assign_teachers_processing'
  match 'getting_started/assign_subjects/edit' => 'getting_started#assign_subjects_edit'
  match 'getting_started/assign_subjects/update' => 'getting_started#assign_subjects_update'

  match 'setup_info' => 'getting_started#setup_info'
  match 'default_subjects' => 'ajax#default_subjects'

  ##dashboard urls
  match 'students' => 'home#students_index'
  match 'students/upload_file/new' => 'home#students_upload_file'
  match 'students/upload_file/create' => 'home#students_upload_file_create' ,:via => :post
  
  match 'teachers' => 'home#teachers_index'
  match 'teachers/upload_file/new' => 'home#teachers_upload_file'
  match 'teachers/upload_file/create' => 'home#teachers_upload_file_create' ,:via => :post

  match 'classes' => 'home#classes_index_simple'



  ##ajax urls
  match 'ajax_login/:user_type/:user_name/:password' => 'login#ajax_login'
  match 'ajax/task_status/:task_id' => 'ajax#task_status'
  match 'ajax/attendance_report/institute' => 'ajax#institute_attendance_report'
  match 'ajax/attendance_report/section/:section_id' => 'ajax#section_attendance_report'
  match 'ajax/attendance_report/student/:student_id' => 'ajax#student_attendance_report'
  match 'ajax/performance_report/institute' => 'ajax#institute_performance_report'
  match 'ajax/performance_report/section/:section_id' => 'ajax#section_performance_report'
  match 'ajax/fees_report/institute' => 'ajax#institute_fees_report'
  match 'ajax/fees_report/section/:section_id' => 'ajax#section_fees_report'
  match 'section/:section_id/update_teacher/:teacher_id' => 'ajax#section_update_teacher' ,:via => :put
  match 'ajax/delete/section/:section_id' => 'ajax#delete_section' 
  match 'ajax/delete/batch/:batch_id' => 'ajax#delete_batch' 

  ##print ursl
  match 'print/details/students' => 'print#student_details'
  match 'print/details/teachers' => 'print#teacher_details'
  match 'print/report_card/:student_id' => 'print#report_card'

  ##profile urls
  match 'profiles/:user_id/show' => 'profile#user_profile'
  match 'profiles/:user_id/edit' => 'profile#user_detail_edit'
  match 'profiles/:user_id/update' => 'profile#user_detail_update'
  match 'profiles/:user_id/reset_password' => 'profile#password_edit'
  match 'profiles/:user_id/update_password' => 'profile#password_update' ,:via => :post
  match 'profiles/:user_id/change_picture' => 'iframe#change_user_picture' 
  match 'profiles/:user_id/profile_picture_update' => 'iframe#profile_picture_update' 

  ##tmp urls
  match 'whitelist/show' => 'home#whitelist_numbers'
  match 'whitelist/update' => 'home#whitelist_numbers_update' ,:via => :post
  match 'whitelist/:id/delete' => 'home#whitelist_number_delete'
  match 'upload_video/new' => 'home#upload_video_new'
  match 'upload_video/create' => 'home#upload_video_create' ,:via => :post

  match 'educational_videos/show' => 'home#video_search'
  match 'educational_videos/search' => 'home#video_search' ,:via => :post

  ##iframe routes
  match 'iframe/close' => 'iframe#close'
  match 'iframe/:student_id/attendance' => 'iframe#student_attendance'
  match 'iframe/:student_id/fees' => 'iframe#student_fees'

  ##edit links for help
  match 'help/topics/list' => 'help#topics'
  match 'help/topics/create' => 'help#topic_create' ,:via => :post
  match 'help/topics/:topic_id/edit' => 'help#topic_edit'
  match 'help/topics/:topic_id/update' => 'help#topic_update',:via => :post
  match 'help/topics/:topic_id/show' => 'help#topic_edit_show'
  match 'help/subtopics/:subtopic_id/edit' => 'help#subtopic_edit'
  match 'help/subtopics/:subtopic_id/update' => 'help#subtopic_update' ,:via => :post
  ## display links for password
  match 'help' => 'help#home'
  match '/help/show/topic/:topic_id' => 'help#topic_show'
  match '/help/show/subtopic/:subtopic_id' => 'help#subtopic_show'

end

