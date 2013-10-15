class LanguagesController < ApplicationController

  def find_id
    @language = Language.find_by_name(params[:language])
    render json: { data: @language }
  end 

end
