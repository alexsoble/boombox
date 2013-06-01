Boombox::Application.routes.draw do

  root to: 'videos#index'

  get '/welcome' => 'videos#index'
  
  resources :videos
  
  post '/new_video' => 'videos#create'
  post '/new_interp' => 'interpretations#create'
  post '/new_line' => 'lines#create'
  
end