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
    if @update[:duration].present?
      @line.duration = @update[:duration]
      @line.save
    end
    if @update[:lang1].present?
      @line.lang1 = @update[:lang1]
      @line.save
    end
    if @update[:lang2].present?
      @line.lang2 = @update[:lang2]
      @line.save
    end
    render :json => { :data => @line }

  end

  def previous
    # find the previous line -- it's the one with the highest "time" that's lower than the line just entered
    # update its duration -- it's equal to the difference between the two lines' start times
    # render back the data
  end

  def destroy
    @line = Line.find_by_id(params[:line][:id])
    @line.destroy
    @line.save
    render :json => { :data => @line }
  end

end
