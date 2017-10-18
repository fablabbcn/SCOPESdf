Rails.application.routes.draw do

  root to: 'visitors#index'

  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'} # CSRF_forgery makes this fail :3

  resources :users

  # -- Lessons

  resources :lessons do
    member do
      get 'show' => 'lessons#show' # a dummy route to show dummy lesson
      delete :delete
      put :publish
      post :upload_file, as: :upload_file_for
      delete :delete_file, as: :delete_file_for
    end
    resources :steps do
      post :upload_file
      delete :delete_file
    end
    resources :standards
  end

  #get  'lessons/new' => 'lessons#new', as: :lesson_new
  # post 'lessons'            => 'lessons#create'#, as: :lesson_create
  #post 'lessons/new'            => 'lessons#new', as: :lesson_create
  # the above line is strictly used for the weekend of the 13/7/2017 for submit on new page loads

  #get 'lessons/test'  => 'lessons#test', as: :lesson_test

  #post '/lessons/:id/publish' => 'lessons#publis', as: :lesson_publish#--
  #put  'lessons/:id'        => 'lessons#update'
  #delete 'lessons/:id' => 'lessons#delete', as: :lesson_delete #--

  #post 'lessons/:id/step'   => 'lessons#add_step'

  #delete 'lessons/:id/step/:step_id'   => 'lessons#delete_step'

  #get 'lessons/:id/file/:attr', to: 'lessons#file_upload_load', as: :lesson_file_data
  #post 'lessons/:id/file/:attr', to: 'lessons#file_upload', as: :lesson_file
  #delete 'lessons/:id/file', to: 'lessons#remove_file_upload', as: :delete_lesson_file
  #~~~~~~~~~~

  #get 'lessons/:id/:step/file/:attr', to: 'lessons#step_file_upload_load', as: :lesson_step_file_data
  #post 'lessons/:id/:step/file/:attr', to: 'lessons#step_file_upload', as: :step_file
  #delete 'lessons/:id/:step/file', to: 'lessons#step_remove_file_upload', as: :delete_step_file

  #get 'lessons/:id'        => 'lessons_public#show', as: :lesson_view
  #get 'list/lessons'  => 'lessons_public#list', as: :lesson_list

  #~~~~ Steps Ajax
  #put     'lessons/:id/steps' => 'lessons#set_steps'
  #delete  'lessons/:id/steps' => 'lessons#remove_step'
  #~~~~~~~~~~

  # -- .Lessons

  get 'file_form'         => 'visitors#form'
  post 'file_upload'      => 'visitors#file_form_upload',  as: :lesson_file_test

  post 'register' => 'visitors#register_interest', as: :register

  post 'users/affiliate' => 'users#affiliate_organization_id'

  get 'api/users/exists'   =>  'secured_api#user_presence'

  get 'search/:entity', :to => 'search#main', as: :search

  # Static pages
  get 'enter' =>  'visitors#enter', as: :enter
  get 'about' => 'visitors#about', as: :about
  get 'policy' => 'visitors#policy', as: :policy
  get 'get_involved' => 'visitors#get_involved', as: :involved

end
