class InterpretationsController < ApplicationController
  respond_to :json, :html

  # before_filter only: [:show] do |controller|

  #   if current_user
  #     true
  #   else
  #   if params[:id].present?
  #     @interp = Interpretation.find_by_id(params[:id])
  #     @user_id = @interp.user_id
  #     if @interp.published == true
  #       true
  #     elsif params[:clip].present? && params[:clip] == 'yes' && params[:duration].to_i < 12
  #       true
  #     elsif params[:preview].present? && params[:preview] == 'yes'
  #       true
  #     elsif current_user
  #       controller.correct_user(@user_id)
  #     end
  #   end
  # end

  before_filter only: [:edit, :publish, :destroy] do |controller|
    if params[:id].present?
      @interp = Interpretation.find_by_id(params[:id])
      @user_id = @interp.user_id
    end
    controller.correct_user(@user_id)
  end

  def save
    
    @interp = Interpretation.find_by_id(params[:interp_id])

    @raw_original_lines = Line.where(:interpretation_id => @interp.id).to_a
    @original_lines = []

    @raw_original_lines.each do |l|
      @original_lines << {"id" => l.id, "lang1" => l.lang1, "lang2" => l.lang2, "time" => l.time.to_i, "duration" => l.duration.to_i }
    end
    @original_lines = @original_lines.sort { |a, b| a["time"] <=> b["time"] }

    @raw_new_lines = JSON.parse(params[:lines])
    @new_lines = []

    @raw_new_lines.each do |l|
      @new_lines << {"id" => l["id"].to_i, "lang1" => l["lang1"], "lang2" => l["lang2"], "time" => l["time"].to_i, "duration" => l["duration"].to_i }
    end 
    @new_lines = @new_lines.sort { |a, b| a["time"] <=> b["time"] }

    if @original_lines == @new_lines
      
      render :json => { :data => "no change" }

    else 
  
      @shared_lines = @original_lines & @new_lines
      @lines_to_delete = @original_lines - @shared_lines
      @lines_to_add = @new_lines - @shared_lines
      logger.debug "@lines_to_delete: #{@lines_to_delete}"
      logger.debug "@lines_to_add: #{@lines_to_add}"

      if @lines_to_delete.present?
        @lines_to_delete.each do |l|
          line = Line.find_by_id(l["id"])
          line.destroy
          line.save
        end
      end

      @lines_to_add.each do |l|
        logger.debug "adding line: #{l}"
        l["interpretation_id"] = @interp.id
        Line.create(l)
      end

      @saved_lines = Line.where(:interpretation_id => @interp.id)
      logger.debug "@saved_lines: #{@saved_lines.all}"

      render :json => { :data => @saved_lines }

    end

  end

  def show
    @interp = Interpretation.find_by_id(params[:id])
    @video = @interp.video
    @user = User.find_by_id(@interp.user_id)
    @lines = Line.where(:interpretation_id => @interp.id).order("time ASC")

    render "videos/show"

    # @translator = User.find_by_id(@interp.user_id)
    # @first_line = @lines.where("lang2 <> ''").first
    # @next_line = @lines.where("lang2 <> ''").offset(1).first
    # @note = @interp.note

    # @keywords = []
    # Keyword.where(:interpretation_id => @interp.id).each do |k|
    #   @keywords << k.word_text
    # end

    # @comments = []
    # @lines.each do |l|
    #   if Comment.where(:line_id => l.id).present?
    #     @comments << { l.id => Comment.where(:line_id => l.id).limit(10) }
    #   end
    # end
    # logger.debug "comments: #{@comments}"

    # @lang1_and_lang2 = false
    # @lines.each do |l|
    #   if l.lang1.present? && l.lang1 != "undefined"
    #     @lang1_and_lang2 = true
    #   end
    # end

    # @url = request.url
    # @lang2 = @interp.lang2
    # @lang1 = @video.lang1
    # @published = @interp.published

    # if @interp.published == true then @published = true else @published = false end

    # if @interp.user_id == 0
    #   @user = 'anon' 
    # else
    #   @user = User.find_by_id(@interp.user_id)
    # end

  end

  def create 
    @interp = Interpretation.create(user_id: params[:user_id], video_id: params[:video_id])
    render :json => { :data => @interp }
  end

  def find
    @interp = Interpretation.where(:user_id => params[:user_id], :video_id => params[:video_id]).first
    if @interp.present?
      render :json => { :interp_id => @interp.id }
    else
      render :json => { :interp_id => 'no-interp' } 
    end
  end 

  def edit

    @interp = Interpretation.find_by_id(params[:id])
    @translator = User.find_by_id(@interp.user_id)
    @note = @interp.note
    @video = @interp.video
    @lang1 = @video.lang1
    @lang2 = @interp.lang2
    @published = @interp.published
    @lines = Line.where(:interpretation_id => @interp.id).order("time ASC")

    @keywords = []
    Keyword.where(:interpretation_id => @interp.id).each do |k|
      @keywords << k.word_text
    end

    @lines.each do |l|
      if l.lang1.present? then @lang1_and_lang2 = true end
    end

    unless @translator.id == current_user.id
      redirect_to home_path
    end

    render "show"
    
  end

  def update_note
    @interp = Interpretation.find_by_id(params[:id])
    @note = params[:note]
    @interp.note = @note
    @interp.save
    render :json => { :data => @interp.note }
  end

  def publish 
    @interp = Interpretation.find_by_id(params[:id])
    @interp.published = true
    @interp.save
    render :json => { :data => @interp }
  end

  def unpublish 
    @interp = Interpretation.find_by_id(params[:id])
    @interp.published = false
    @interp.save
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

  def print_pdf
    require 'prawn'

    @interp = Interpretation.find_by_id(params[:id])
    @video = @interp.video
    @translator = User.find_by_id(@interp.user_id)
    @lines = Line.where(:interpretation_id => @interp.id).sort { |a, b| a.time <=> b.time }
 
    tmp_file = Tempfile.new(Digest::MD5.hexdigest(rand(12).to_s))
    Prawn::Document.generate(tmp_file.path()) do |pdf|

      pdf.text "#{@video.title}", :align => :center, :size => 18
      pdf.text "Translated from #{@video.lang1} by #{@translator.username}", :align => :center, :size => 14
      pdf.move_down 12
      link = "www.heyuvideo.com/interpretations/#{@interp.id}"
      pdf.text "Watch on Heyu: <color rgb='15130245'><u><link href=#{link}>#{link}</link></u></color>", :align => :center, :size => 10, :inline_format => true

      pdf.move_down 36

      @lines.each do |l|
        pdf.column_box([0, pdf.cursor], :columns => 2, :width => pdf.bounds.width) do
          pdf.text("#{l.lang1}")
          pdf.bounds.move_past_bottom
          pdf.text("#{l.lang2}")
        end
        pdf.move_down 12
        if pdf.cursor < 20 then pdf.start_new_page end
      end
    end

    send_file tmp_file,
              :content_type => "application/pdf",
              :filename => "#{@video.title} - translation by #{@translator.firstname}.pdf"

  end

  def print_txt

    @interp = Interpretation.find_by_id(params[:id])
    @video = @interp.video
    @translator = User.find_by_id(@interp.user_id)
    @lines = Line.where(:interpretation_id => @interp.id).sort { |a, b| a.time <=> b.time }
 
    tmp_file = Tempfile.new(Digest::MD5.hexdigest(rand(12).to_s))
    File.open(tmp_file, 'w') do |f|  
      f.puts "#{@video.title}"  
      f.puts "\n"  
      f.puts "Translated from #{@video.lang1} by #{@translator.username}" 
      f.puts "\n"  
      f.puts "#{@video.lang1.upcase}"  
      @lines.each do |l|
        f.puts l.lang1  
      end
      f.puts "\n"  
      f.puts "#{@interp.lang2.upcase}"  
      @lines.each do |l|
        f.puts l.lang2
      end
    end  

    send_file tmp_file,
              :filename => "#{@video.title} - translation by #{@translator.firstname}.txt"

  end

  def print_google

    if params[:stage] == 'new'
       session[:interp_to_export_to_google] = params[:id]
       redirect_to "/auth/google"
    end
    
  end 

  def get_by_language
    # send the most popoular 20 videos that match whatever lang is sent in via AJAX
    # send the title and youtube_id along with so it can get displayed in the index page
  end

end
