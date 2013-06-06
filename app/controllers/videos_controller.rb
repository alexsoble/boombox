class VideosController < ApplicationController
  require 'json'
  respond_to :html, :json

  def create

    @youtube_id = params[:video][:youtube_id]
    @lang1 = params[:video][:lang1]
    if Video.where(:youtube_id => @youtube_id).blank? 
      @video = Video.create(params[:video])
    else
      @video2 = Video.where(:youtube_id => @youtube_id).first
      if @video2.lang1 != @lang1
        @video = Video.create(params[:video])
      end

      # ^ You'll want to make this code better later on.  
      # Right now it's just checking the first item in @video2 against lang1. 
      # But thankfully this will probably be an uncommon situation. 
    end

    render :json => { :video => @video }

  end

  def show 

    @video = Video.find_by_id(params[:id])

    @interpretations = Interpretation.where(:video_id => @video.id).order("created_at ASC")

    if @interpretations.present?

      arr = Array.new 

      @interpretations.each do |i|
        l = Line.where(:interpretation_id => i.id).order("created_at ASC")
        how_many_lines = l.length
        arr << { :id => i.id, :length => how_many_lines }
      end 
      
      arr = arr.sort_by { |hash| hash[:length] }.reverse
      @interpretation = Interpretation.where(:id => arr.first[:id]).first
      @lines = Line.where(:interpretation_id => @interpretation.id).order("created_at ASC")
      @lines_have_lang1 = false
      @lines.all.each do |l|
        if l.lang1.present? then @lines_have_lang1 = true end
      end 

    end
    
  end 

  def index

  end

  def new

  end

end
