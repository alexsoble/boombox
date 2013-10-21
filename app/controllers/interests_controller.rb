class InterestsController < ApplicationController

  def create
    @interest = Interest.create(params[:interest])
    render json: { data: @interest }
  end

  def destroy
    @interest = Interest.find_by_id(params[:id])
    @interest.destroy
    if @interest.save then render json: { data: @interest } else render json: { data: 'save_failed' } end
  end

end
