Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'} # CSRF_forgery makes this fail :3
  resources :users

  post 'lessons'            => 'lessons#create', as: :lesson_create
  put  'lessons/:id'        => 'lessons#update'
  post 'lessons/:id/steps'   => 'lessons#add_step'
  post 'lessons/:id/file/:atr', to: 'lessons#fileUpload', as: :lesson_file



  get 'file_form'         => 'visitors#form'
  post 'file_upload'      => 'visitors#file_form_upload'



  post 'users/affiliate' => 'users#affiliate_organization_id'


  get 'api/users/exists'   =>  'secured_api#user_presence'

  post 'search/:entity', :to => 'search#main', :as => :search


end
