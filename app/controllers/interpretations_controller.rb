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
      else
        controller.correct_user(@user_id)
      end
    end
  end

  def save
    @interp = Interpretation.find_by_id(params[:interp_id])
    @original_lines = Line.where(:interpretation_id => @interp.id)

    if @original_lines.present?
      @original_lines.all.each do |o|
        o.destroy
        o.save
      end
    end

    @lines = JSON.parse(params[:lines])
    puts @lines
    @lines.each do |l|
      Line.create(l)
    end

    @new_lines = Line.where(:interpretation_id => @interp.id)

    render :json => { :data => @new_lines }
  end

  def show
    @interp = Interpretation.find_by_id(params[:id])
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
    redirect_to '/welcome'
  end

  def get_by_language
    # send the most popoular 20 videos that match whatever lang is sent in via AJAX
    # send the title and youtube_id along with so it can get displayed in the index page
  end

end
