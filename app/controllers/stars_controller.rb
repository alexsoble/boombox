class StarsController < ApplicationController

  def create
    @star = Star.create(params[:star])
    render :json => { :data => @star }
  end

  def destroy
    @star = Star.find_by_id(params[:star_id])
    @star.destroy
    @star.save
    render :json => { :data => @star }
  end

end
