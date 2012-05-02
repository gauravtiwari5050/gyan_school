GyanSchool::Application.routes.draw do
  match '/' => 'static#land'
  match '/signup' => 'signup#signup'
  match '/institute/create' => 'signup#register' ,:via => :post
  match 'login' => 'login#login'
  match 'login/school' => 'login#login_employee' ,:via => :post
  match 'login/student' => 'login#login_student' ,:via => :post
  match 'home' => 'home#home'
  match 'session/new' => 'home#session_new'
  match 'session/:session_id/edit' => 'home#session_edit'
  match 'session/:session_id/update' => 'home#session_update',:via =>:post
  match 'session/:session_id/delete' => 'home#session_delete'
  match 'sessions/index' => 'home#session_index'
  match 'session/create' => 'home#session_create' ,:via => :post
  match 'batch/new' => 'home#batch_create'

end
