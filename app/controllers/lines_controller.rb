class LinesController < ApplicationController
  respond_to :json

  def create 
    
    @line = Line.create(params[:line])
    
    render :json => { :data => @line }

    end

end
