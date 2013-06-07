Boombox::Application.routes.draw do

  root to: 'videos#index'

  get '/welcome' => 'videos#index'

  get '/sign_up' => 'users#new'
  get '/sign_in' => 'sessions#new'
  get '/sign_out' => 'sessions#destroy'
  get '/auth/:provider/callback' => 'sessions#create'
  
  get '/request/' => 'videos#request'
  resources :videos
  resources :users
  resources :sessions
  
  post '/new_video' => 'videos#create'
  post '/new_request' => 'requests#create'
  post '/new_interp' => 'interpretations#create'
  post '/new_line' => 'lines#create'
  
end