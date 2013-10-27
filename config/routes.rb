Boombox::Application.routes.draw do

  root to: 'pages#welcome'

  get '/welcome' => 'pages#welcome'
  get '/home' => 'pages#home'
  get '/chile' => 'pages#chile'

  get '/join' => 'users#new'
  get '/sign_in' => 'sessions#new'
  get '/sign_out' => 'sessions#destroy'
  get '/auth/:provider/callback' => 'sessions#create_with_omniauth'
  get '/new' => 'pages#new' 
  get '/teachers' => 'pages#teachers'

  resources :videos
  resources :interpretations
  resources :translations
  resources :transcripts, path: :lyrics
  resources :tags
  resources :definitions
  resources :challenges
  resources :clips
  resources :users
  resources :sessions
  resources :classrooms
  resources :discussion_questions
  resources :fill_exercises, path: :fill_in_the_blanks

  post '/find_video' => 'videos#find'

  post '/find_language' => 'languages#find_id'
  post '/find_language_by_id' => 'languages#find_name'
  post '/language_list' => 'languages#list'

  post '/student_list' => 'users#list'
  post '/update_user' => 'users#update'
  post '/new_classroom' => 'classrooms#create'
  get '/teachers/:id' => 'users#teacher_dashboard'

  post '/new_tag' => 'tags#create'

  post '/add_star' => 'stars#create'
  post 'remove_star' => 'stars#destroy'

  get '/transcripts/:id/embed.js' => 'transcripts#embed'
  post '/find_transcript' => 'transcripts#find'
  post '/find_transcripts' => 'transcripts#find'
  post '/new_transcript' => 'transcripts#create'

  post '/new_fill_exercise' => 'fill_exercises#create'
  post '/find_fill_exercise' => 'fill_exercises#find'
  post '/destroy_fill_exercise' => 'fill_exercises#destroy'
  post '/new_completed_exercise' => 'completed_exercises#create'
  
  post '/new_word' => 'words#create'
  post '/add_time_to_word' => 'words#update_time'

  post '/new_missing_word' => 'missing_words#create'
  post '/destroy_missing_word' => 'missing_words#destroy'

  post '/new_definition' => 'definitions#create'
  post '/new_challenge' => 'challenges#create'
  post '/new_option' => 'options#create'
  post '/new_discussion_response' => 'discussion_responses#create'

  post '/find_playcount/:user_id/:video_id' => 'playcounts#find'
  post '/new_playcount/:user_id/:video_id' => 'playcounts#create'
  post '/update_playcount/:id' => 'playcounts#update'

  post '/find_interp/:user_id/:video_id' => 'interpretations#find'
  post '/new_interp/:user_id/:video_id' => 'interpretations#create'

  post '/new_line' => 'lines#create'
  post '/update_line' => 'lines#update'
  post '/destroy_line' => 'lines#destroy'
  post '/find_lines' => 'lines#find'

  post '/new_translation' => 'translations#create'
  post '/destroy_translation' => 'translations#destroy'
  post '/find_translation' => 'translations#find'

  post '/new_translated_line' => 'translated_lines#create'
  post '/update_translated_line' => 'translated_lines#update'

  post '/new_link/' => 'links#create'
  post '/new_tweet/' => 'tweets#create'
  post '/new_discussion_question' => 'discussion_questions#create'
  post '/new_option_vote' => 'option_votes#create'

  post '/new_language_interest' => 'interests#create'
  post '/remove_language_interest' => 'interests#destroy'
  
  post '/new_tag_vote/' => 'tag_votes#create'
  post '/update_tag_vote/' => 'tag_votes#update'

  post '/new_definition_vote/' => 'definition_votes#create'
  post '/update_definition_vote/' => 'definition_votes#update'

  get '/print_pdf/:id' => 'interpretations#print_pdf'
  get '/print_txt/:id' => 'interpretations#print_txt'
  get '/print_google/:stage/:id' => 'interpretations#print_google'

  post '/new_comment' => 'comments#create'
  post '/destroy_comment/' => 'comments#destroy'
  post '/update_comment/' => 'comments#update'
  
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
  get '/admin' => 'pages#admin'

end