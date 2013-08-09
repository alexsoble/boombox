class ClipsController < ApplicationController

  def create

    @clip = Clip.create(params[:clip])
    render :json => { :data => @clip }

  end
  
  def show

    render 'interpretations#show'

  end 

end