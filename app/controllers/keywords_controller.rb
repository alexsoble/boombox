class KeywordsController < ApplicationController

  def create
    @keyword = Keyword.create(params[:keyword])
    render :json => { :data => @keyword }
  end

  def destroy

  end

end
