class RequestsController < ApplicationController
  respond_to :json

  def create

    @request = Request.create(params[:request])

    render :json => { :data => @request }

  end

end
