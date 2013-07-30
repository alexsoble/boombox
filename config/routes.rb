Boombox::Application.routes.draw do

  root to: 'videos#index'

  get '/welcome' => 'videos#index'

  get '/sign_up' => 'users#new'
  get '/sign_in' => 'sessions#new'
  get '/sign_out' => 'sessions#destroy'
  get '/auth/:provider/callback' => 'sessions#create'
  
  resources :videos
  resources :users
  resources :sessions
  resources :interpretations

  get '/interpretations/:id/quiz' => 'interpretations#show'
  
  post '/new_video' => 'videos#create'
  post '/new_interp' => 'interpretations#create'
  post '/publish' => 'interpretations#publish'
  post '/new_request' => 'requests#create'
  post '/save' => 'interpretations#save'

  post '/save_quiz_words' => 'quizzes#update'
  post '/save_quiz' => 'quizzes#create'
  
  get '/philosophy' => 'pages#philosophy'
  get '/survey' => 'pages#survey'
  get '/experiment' => 'pages#experiment'

end