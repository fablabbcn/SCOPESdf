Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'} # CSRF_forgery makes this fail :3
  resources :users

  get  'lessons/new' => 'lessons#new', as: :lesson_new
  post 'lessons'            => 'lessons#create'#, as: :lesson_create
  post 'lessons/new'            => 'lessons#new', as: :lesson_create
  # the above line is strictly used for the weekend of the 13/7/2017 for submit on new page loads

  post '/lessons/:id/publish' => 'lessons#publish'


  put  'lessons/:id'        => 'lessons#update'
  post 'lessons/:id/step'   => 'lessons#add_step'

  delete 'lessons/:id/step/:step_id'   => 'lessons#delete_step'

  post 'lessons/:id/file/:atr', to: 'lessons#file_upload', as: :lesson_file
  delete 'lessons/:id/file', to: 'lessons#remove_file_upload', as: :delete_lesson_file



  get 'lessons/:id'        => 'lessons_public#show', as: :lesson_view



  get 'list/lessons' => 'lessons#list_json'


  get 'file_form'         => 'visitors#form'
  post 'file_upload'      => 'visitors#file_form_upload'


  get 'enter' =>  'visitors#enter', as: :enter
  get 'register' => 'visitors#register_interest', as: :register

  post 'users/affiliate' => 'users#affiliate_organization_id'


  get 'api/users/exists'   =>  'secured_api#user_presence'

  post 'search/:entity', :to => 'search#main', :as => :search





  #~~~~ Steps Ajax
  put     'lessons/:id/steps' => 'lessons#set_steps'
  delete  'lessons/:id/steps' => 'lessons#remove_step'
  #~~~~~~~~~~
end
