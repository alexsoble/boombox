class RequestsController < ApplicationController
  respond_to :json

  def create
    @request = Request.create(params[:request])
    @video = @request.video
    render :json => { :request => @request, :video => @video }
  end

end
