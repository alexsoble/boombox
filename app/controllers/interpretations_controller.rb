class InterpretationsController < ApplicationController
  respond_to :json, :html

  def create 

    @interp = Interpretation.create(params[:interpretation])

    render :json => { :data => @interp }

  end

  def index

    @interps = Interpretation.order('created_at DESC').limit(100)
    @language_filter = params[:lang]
  
  end

  def show

      @interp = Interpretation.find_by_id(params[:id])
      @lines = Line.where(:interpretation_id => @interp.id).order("created_at ASC")

      @lines_have_lang1 = false
      @lines.all.each do |l|
        if l.lang1.present? then @lines_have_lang1 = true end
      end 

      if @interp.user_id == 0
        @user = 'anon'
      else
        @user = User.find_by_id(@interp.user_id)
      end


  end

  def publish 

    @interp = Interpretation.find_by_id(params[:interpretation][:id])
    @interp.published = true
    @interp.save

    @requests = Request.where(:video_id == @interp.video.id)
    # Send the relevant user an Alert here

    render :json => { :data => @interp }

  end

end
