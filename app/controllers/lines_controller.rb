class LinesController < ApplicationController
  respond_to :json

  def create 
    @line = Line.create(params[:line])
    render :json => { :data => @line }
  end

  def update
    @update = params[:line]
    @line = Line.find_by_id(params[:line][:id])
    if @update[:time].present?
      @line.time = @update[:time]
      @line.save
    end
    if @update[:lang1].present?
      @line.lang1 = @update[:lang1]
      @line.save
    end
    if @update[:lang2].present?
      @line.time = @update[:lang2]
      @line.save
    end
    render :json => { :data => @line }
  end

end
