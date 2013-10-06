class DefinitionsController < ApplicationController

  def create
    @definition = Definition.create(params[:definition])
    render :json => { :data => @definition }
  end

  def show

    @definition = Definition.find_by_id(params[:id])
    @definition_creator = User.find_by_id(@word.user_id)
    @definition_video = Video.find_by_id(@word.video_id)

  end

  def destroy

    @definition = Definition.find_by_id(params[:id])
    @word = Word.find_by_id(@definition.word_id)
    @definition_video = Video.find_by_id(@word.video_id)
    @definition.destroy
    @definition.save
    @word.destroy
    @word.save
    redirect_to video_url(@definition_video)

  end

end
