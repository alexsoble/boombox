Boombox::Application.routes.draw do

  root to: 'videos#index'

  get '/welcome' => 'videos#index'

  get '/sign_up' => 'users#new'
  get '/sign_in' => 'sessions#new'
  get '/sign_out' => 'sessions#destroy'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/philosophy' => 'pages#philosophy'
  get '/survey' => 'pages#survey'
  get '/help' => 'pages#help'

  get '/request/' => 'videos#request'
  resources :videos
  resources :users
  resources :sessions
  resources :interpretations
  
  post '/new_video' => 'videos#create'
  post '/new_interp' => 'interpretations#create'
  post '/publish' => 'interpretations#publish'
  post '/new_request' => 'requests#create'
  post '/new_line' => 'lines#create'
  post '/update_line' => 'lines#update' 
  post '/delete_line' => 'lines#destroy'
  post '/previous_line' => 'lines#previous'
  get '/requests_by_language' => 'requests#get_by_language'
  get '/interps_by_language' => 'interpretations#get_by_language'

end