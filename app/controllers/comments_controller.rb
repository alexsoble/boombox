class CommentsController < ApplicationController
  respond_to :json, :html

  def create
    @comment = Comment.create(params[:comment])
    render :json => { :data => @comment }
  end

  def destroy
    @comment = Comment.find_by_id(params[:id])
    @comment.destroy
    if @comment.save
      render json: { data: @comment }
    else
      render json: { data: "save failed :(" }
    end
  end
  
end