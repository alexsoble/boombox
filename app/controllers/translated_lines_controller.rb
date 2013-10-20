class TranslatedLinesController < ApplicationController

  def create
    @translated_line = TranslatedLine.create(params[:translated_line])
    render json: { data: @translated_line }
  end

end
