GyanSchool::Application.routes.draw do
  match '/' => 'static#land'
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
  match 'batch/index' => 'home#batch_index'
  match 'batch/:batch_id/edit' => 'home#batch_edit'
  match 'batch/:batch_id/show' => 'home#batch_show'
  match 'batch/:batch_id/create' => 'home#batch_update'
  match 'batch/sections/:batch_id' => 'home#sections_for_batch'
  match 'student/new' => 'home#student_new'
  match 'student/:student_id/edit' => 'home#student_edit'
  match 'student/:student_id/create' => 'home#student_update' ,:via => :post
  match 'student/create' => 'home#student_create' ,:via => :post
  match 'teacher/new' => 'home#teacher_new'
  match 'teacher/:teacher_id/edit' => 'home#teacher_edit'
  match 'teacher/:teacher_id/create' => 'home#teacher_update'
  match 'teacher/create' => 'home#teacher_create' ,:via => :post

  match 'subjects/show' => 'home#subjects_show'
  match 'subjects/create' => 'home#subjects_create'

  match 'section/:section_id/update_teacher/:teacher_id' => 'home#section_update_teacher',:via => :put
  match 'section/:section_id/show' => 'home#section_show'
  match 'section/:section_id/attendance' => 'home#section_attendance_home'
  match 'section/:section_id/mark_attendance/:date' => 'home#section_mark_attendance'
  match 'section/:section_id/mark_attendance/:date/update' => 'home#section_mark_attendance_update' ,:via => :post

  match 'fees/schedule_index' => 'home#fees_schedule_index'
  match 'fees/schedule/:fee_event_id/edit' => 'home#fees_schedule_edit'
  match 'fees/schedule/:fee_event_id/create' => 'home#fees_schedule_update'
  match 'fees/schedule/new' => 'home#fees_schedule_new'
  match 'fees/schedule/create' => 'home#fees_schedule_create' ,:via => :post
  match 'fees/collect' => 'home#fees_collect' 
  match 'search/students' => 'home#search_students' 



end
