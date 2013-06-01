class LinesController < ApplicationController
  respond_to :json

  def create 
    
    @line = Line.new(params[:line])
    
      if @line.save
        data = "Saved."
      else
        data = "Failed."
      end

      respond_with data

    end

end
