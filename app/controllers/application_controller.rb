class ApplicationController < ActionController::Base
  protect_from_forgery

  def translated_video_languages
    arr = []
    Video.order("created_at ASC").each do |v|
      arr << v.lang1
    end
    arr
  end 
  helper_method :translated_video_languages

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
  end
  helper_method :current_user

end
