class InterpretationsController < ApplicationController
  respond_to :json

  def create 
  
    @interp = Interpretation.new(params[:interpretation])
    
    if @interp.save
      data = "Saved."
    else
      data = "Failed."
    end

    respond_with data

    redirect_to '/index'

  end

end
