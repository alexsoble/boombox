class RequestsController < ApplicationController
  respond_to :json

  def create
    @request = Request.create(params[:request])
    @video = @request.video
    render :json => { :request => @request, :video => @video }
  end

  def get_by_language
    # send the most popoular 20 videos that match whatever lang is sent in via AJAX
    # send the title and youtube_id along with so it can get displayed in the index page
  end

end
