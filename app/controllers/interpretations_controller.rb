class InterpretationsController < ApplicationController
  respond_to :json, :html

  before_filter only: [:edit, :publish, :destroy] do |controller|
    if params[:id].present?
      @interp = Interpretation.find_by_id(params[:id])
      @user_id = @interp.user_id
    end
    controller.correct_user(@user_id)
  end

  before_filter only: [:show] do |controller|
    if params[:id].present?
      @interp = Interpretation.find_by_id(params[:id])
      @user_id = @interp.user_id
      if @interp.published == true
        true
      elsif params[:clip].present? && params[:clip] == 'yes' && params[:duration].to_i < 12
        true
      elsif params[:preview].present? && params[:preview] == 'yes'
        true
      elsif current_user
        controller.correct_user(@user_id)
      end
    end
  end

  def save
    
    @interp = Interpretation.find_by_id(params[:interp_id])

    @original_lines = Line.where(:interpretation_id => @interp.id).to_a
    @original_lang1 = Array.new
    @original_lang2 = Array.new
    @original_times = Array.new
    @original_durations = Array.new
    @original_lines.each do |l|
      @original_lang1 << l.lang1
      @original_lang2 << l.lang2
      @original_times << l.time.to_i
      @original_durations << l.duration.to_i
    end
    logger.debug "@original_lang1: #{@original_lang1}"
    logger.debug "@original_lang2: #{@original_lang2}"
    logger.debug "@original_times: #{@original_times}"
    logger.debug "@original_durations: #{@original_durations}"

    @new_lines = JSON.parse(params[:lines])
    @new_lang1 = Array.new
    @new_lang2 = Array.new
    @new_times = Array.new
    @new_durations = Array.new
    @new_lines.each do |l|
      @new_lang1 << l["lang1"]
      @new_lang2 << l["lang2"]
      @new_times << l["time"].to_i
      @new_durations << l["duration"].to_i
    end
    logger.debug "@new_lang1: #{@new_lang1}"
    logger.debug "@new_lang2: #{@new_lang2}"
    logger.debug "@new_times: #{@new_times}"
    logger.debug "@new_durations: #{@new_durations}"

    if @original_lang1 != @new_lang1 || @new_lang2 != @original_lang2 || @original_times != @new_times || @new_durations != @original_durations

      if @original_lines.present?
        @original_lines.each do |o|
          o.destroy
          o.save
        end
      end

      @new_lines.each do |l|
        Line.create(l)
      end

      @saved_lines = Line.where(:interpretation_id => @interp.id)
      logger.debug "@saved_lines: #{@saved_lines}"

      render :json => { :data => @saved_lines }

    else

      render :json => { :data => "no change" }

    end

  end

  def show
    @interp = Interpretation.find_by_id(params[:id])
    @user = User.find_by_id(@interp.user_id)
    @video = @interp.video
    @lines = Line.where(:interpretation_id => @interp.id).order("created_at ASC")
    @url = request.url

    if @interp.published == true then @published = true else @published = false end

    if params[:clip] == 'yes'
      @clip = true
      @start = params[:start]
      @duration = params[:duration]
    else 
      @clip = false
    end

    @lines_have_lang1 = false
    line_length = []
    @lines.all.each do |l|
      if l.lang1.present? then @lines_have_lang1 = true end
      line_length << l.lang1.length 
      line_length << l.lang2.length 
    end 
    @longest_line_length = line_length.max

    if @interp.user_id == 0
      @user = 'anon' 
    else
      @user = User.find_by_id(@interp.user_id)
    end

    @lang2 = @interp.lang2
    @lang1 = @video.lang1
    @published = @interp.published
    @lines = Line.where(:interpretation_id => @interp.id).order("created_at ASC")
    @lines.each do |l|
      if l.lang1.present? then @lang1_and_lang2 = true end
    end

  end

  def create 
    @interp = Interpretation.create(params[:interpretation])
    render :json => { :data => @interp }
  end

  def index
    @interps = Interpretation.order('created_at DESC').limit(100)
    @language_filter = params[:lang]
  end

  def edit

    @interp = Interpretation.find_by_id(params[:id])
    @user = User.find_by_id(@interp.user_id)
    @lang2 = @interp.lang2
    @video = @interp.video
    @lang1 = @video.lang1
    @published = @interp.published
    @lines = Line.where(:interpretation_id => @interp.id).order("created_at ASC")
    @lines.each do |l|
      if l.lang1.present? then @lang1_and_lang2 = true end
    end

    unless @user.id == current_user.id
      redirect_to home_path
    end

    render "show"
    
  end

  def publish 
    @interp = Interpretation.find_by_id(params[:id])
    @interp.published = true
    @interp.save

    @requests = Request.where(:video_id == @interp.video.id)
    # Send the relevant user an Alert here

    render :json => { :data => @interp }
  end

  def destroy
    @interp = Interpretation.find_by_id(params[:id])
    @interp.destroy
    @lines = Line.where(:interpretation_id => @interp.id).order("created_at ASC")
    @lines.each do |l|
      l.destroy
    end
    redirect_to :back
  end

  def get_by_language
    # send the most popoular 20 videos that match whatever lang is sent in via AJAX
    # send the title and youtube_id along with so it can get displayed in the index page
  end

end
