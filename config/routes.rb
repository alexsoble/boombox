Boombox::Application.routes.draw do

  root to: 'videos#index'

  get '/welcome' => 'videos#index'
  
  resources :videos
  
end
