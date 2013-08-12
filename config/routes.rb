Boombox::Application.routes.draw do

  root to: 'pages#welcome'

  get '/welcome' => 'pages#welcome'
  get '/home' => 'pages#home'

  get '/join' => 'users#new'
  get '/steptwo' => 'users#steptwo'
  get '/stepthree' => 'users#stepthree'
  get '/sign_in' => 'sessions#new'
  get '/sign_out' => 'sessions#destroy'
  get '/auth/:provider/callback' => 'sessions#create'
  
  resources :videos
  resources :interpretations
  resources :clips
  resources :users
  resources :sessions

  get '/interpretations/:id/discuss' => 'interpretations#show'
  
  post '/new_video' => 'videos#create'
  post '/new_interp' => 'interpretations#create'
  post '/publish' => 'interpretations#publish'
  post '/unpublish' => 'interpretations#unpublish'
  post '/new_request' => 'requests#create'
  post '/save' => 'interpretations#save'

  post '/edit_bio' => 'users#stepthree'
  post '/upvote' => 'votes#up'
  post '/downvote' => 'votes#down'
  
  get '/philosophy' => 'pages#philosophy'
  get '/survey' => 'pages#survey'
  get '/experiment' => 'pages#experiment'
  get '/browsers' => 'pages#browsers'
  get '/errors' => 'pages#error'
  
  resources :quizzes
  post '/save_quiz_words' => 'quizzes#save_words'
  post '/new_quiz' => 'quizzes#create'

end