class TranslatedLinesController < ApplicationController

  def create
    @translated_line = TranslatedLine.create(params[:translated_line])
    render json: { data: @translated_line }
  end

  def update
    @update = params[:translated_line]
    @translated_line = TranslatedLine.find_by_id(@update[:id])

    if @update[:lang2].present?
      @translated_line.lang2 = @update[:lang2]
      @translated_line.save
    end
    render :json => { :data => @translated_line }

  end

end
