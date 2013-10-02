class OptionsController < ApplicationController

  def create
    @option = Option.create(params[:option])
    render :json => { :data => @option }
  end

end
