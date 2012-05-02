GyanSchool::Application.routes.draw do
  match '/' => 'static#land'
  match '/signup' => 'signup#signup'
  match '/institute/create' => 'signup#register' ,:via => :post
  match 'login' => 'login#login'
  match 'login/school' => 'login#login_employee' ,:via => :post
  match 'login/student' => 'login#login_student' ,:via => :post
  match 'home' => 'home#home'
  match 'session/new' => 'home#session_new'
  match 'session/index' => 'home#session_index'
  match 'session/create' => 'home#session_create' ,:via => :post

end
