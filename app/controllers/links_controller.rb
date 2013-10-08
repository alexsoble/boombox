class LinksController < ApplicationController

  def create
    @link = Link.create(params[:link])
    @link_lang = Language.where(:name => params[:lang]).first
    @link.language_id = @link_lang.id
    if @link.save
      render :json => { :data => @link }
    else
      render :json => { :data => 'save-failed' }
    end
  end

end