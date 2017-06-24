Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'} # CSRF_forgery makes this fail :3
  resources :users

  post 'lessons' => 'lessons#create'

  post 'users/affiliate' => 'users#affiliate_organization_id'

end
