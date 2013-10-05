Boombox::Application.routes.draw do

  root to: 'pages#welcome'

  get '/welcome' => 'pages#welcome'
  get '/home' => 'pages#home'
  get '/chile' => 'pages#chile'

  get '/join' => 'users#new'
  get '/steptwo' => 'users#steptwo'
  get '/stepthree' => 'users#stepthree'
  get '/sign_in' => 'sessions#new'
  get '/sign_out' => 'sessions#destroy'
  get '/auth/:provider/callback' => 'sessions#create_with_omniauth'
  
  resources :videos
  resources :interpretations
  resources :tags
  resources :definitions
  resources :clips
  resources :users
  resources :sessions

  post '/new_tag' => 'tags#create'

  post '/new_word' => 'words#create'
  post '/add_time_to_word' => 'words#update_time'
  post '/new_definition' => 'definitions#create'
  post '/new_challenge' => 'challenges#create'
  post '/new_option' => 'options#create'

  post '/find_playcount/:user_id/:video_id' => 'playcounts#find'
  post '/new_playcount/:user_id/:video_id' => 'playcounts#create'
  post '/update_playcount/:id' => 'playcounts#update'

  post '/find_interp/:user_id/:video_id' => 'interpretations#find'
  post '/new_interp/:user_id/:video_id' => 'interpretations#create'

  get '/print_pdf/:id' => 'interpretations#print_pdf'
  get '/print_txt/:id' => 'interpretations#print_txt'
  get '/print_google/:stage/:id' => 'interpretations#print_google'

  post '/new_comment' => 'comments#create'
  post '/delete_comment/' => 'comments#destroy'
  
  post '/new_video' => 'videos#create'
  post '/new_interp' => 'interpretations#create'
  post '/save' => 'interpretations#save'
  post '/update_note' => 'interpretations#update_note'
  post '/publish' => 'interpretations#publish'
  post '/unpublish' => 'interpretations#unpublish'

  post '/create_keyword' => 'keywords#create'
  post '/remove_keyword' => 'keywords#destroy'
  post '/new_clip' => 'clips#create'
  post '/upvote' => 'votes#up'
  post '/downvote' => 'votes#down'
  
  post '/update_user' => 'users#update'
    
  get '/philosophy' => 'pages#philosophy'
  get '/about' => 'pages#philosophy'
  get '/survey' => 'pages#survey'
  get '/experiment' => 'pages#experiment'
  get '/browsers' => 'pages#browsers'
  get '/translate' => 'pages#translate'
  get '/errors' => 'pages#error'
  get '/terms' => 'pages#terms'
  get '/dmca' => 'pages#dmca'
  get '/thanks' => 'pages#thankyou'
  get '/contact' => 'pages#contact'

end