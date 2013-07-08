class ApplicationController < ActionController::Base
  protect_from_forgery

  def translated_video_languages
    arr = []
    Interpretation.order("created_at ASC").each do |i|
      if arr.grep(i.lang1).blank? && i.lang1 != 'undefined'
        arr << i.lang1
      end
    end
    arr
  end 
  helper_method :translated_video_languages

  def requested_video_languages
    arr = []
    Request.order("created_at ASC").each do |r|
      if arr.grep(r.lang2).blank? && r.lang2 != 'undefined'
        arr << { r.lang1 => r.lang2 }
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
