class DefinitionsController < ApplicationController

  def create
    @definition = Definition.create(params[:definition])
    render :json => { :data => @definition }
  end

  def show

    @definition = Definition.find_by_id(params[:id])
    @word = Word.find_by_id(@definition.word_id)
    @definition_creator = User.find_by_id(@word.user_id)
    @definition_video = Video.find_by_id(@word.video_id)

  end

end
