class CommentsController < ApplicationController
  respond_to :json, :html

  def create

    @comment = Comment.create(params[:comment])
    render :json => { :data => @comment }

  end

end