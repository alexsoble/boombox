class TranslationsController < ApplicationController

  def create 
    @translation = Translation.create(params[:translation])
    render :json => { :data => @translation }
  end

end
