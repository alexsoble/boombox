class DefinitionsController < ApplicationController

  def create
    @definition = Definition.create(params[:definition])
    render :json => { :data => @definition }
  end

end
