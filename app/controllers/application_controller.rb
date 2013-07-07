class ApplicationController < ActionController::Base
  protect_from_forgery

  def translated_video_languages
    arr = []
    Video.order("created_at ASC").each do |v|
      if arr.grep(v.lang1).blank? && v.lang1 != 'undefined'
        arr << v.lang1
      end
    end
    arr
  end 
  helper_method :translated_video_languages

  def requested_video_languages
    arr = []
    Request.order("created_at ASC").each do |r|
      if arr.grep(r.lang2).blank? && r.lang2 != 'undefined'
        arr << r.lang2
      end
    end
    arr
  end 
  helper_method :requested_video_languages

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
  end
  helper_method :current_user
  
end
