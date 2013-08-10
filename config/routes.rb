Boombox::Application.routes.draw do

  root to: 'videos#index'

  get '/welcome' => 'videos#index'

  get '/join' => 'users#new'
  get '/steptwo' => 'pages#steptwo'
  get '/sign_in' => 'sessions#new'
  get '/sign_out' => 'sessions#destroy'
  get '/auth/:provider/callback' => 'sessions#create'
  
  resources :videos
  resources :interpretations
  resources :users
  resources :sessions
  
  get '/translate' => 'pages#translate'
  get '/interpretations/:id/discuss' => 'interpretations#show'
  
  post '/new_video' => 'videos#create'
  post '/new_interp' => 'interpretations#create'
  post '/publish' => 'interpretations#publish'
  post '/unpublish' => 'interpretations#unpublish'
  post '/new_request' => 'requests#create'
  post '/save' => 'interpretations#save'

  post '/upvote' => 'votes#up'
  post '/downvote' => 'votes#down'
  
  get '/philosophy' => 'pages#philosophy'
  get '/survey' => 'pages#survey'
  get '/experiment' => 'pages#experiment'
  get '/browsers' => 'pages#browsers'

  resources :quizzes
  post '/save_quiz_words' => 'quizzes#save_words'
  post '/new_quiz' => 'quizzes#create'

end