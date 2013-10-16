class LanguagesController < ApplicationController

  def list
    term = params[:term]
    term_length = term.length

    @languages = []
    Language.all.each do |l|
      if l.name[0..(term_length - 1)].upcase == term.upcase
        @languages << l
      end
    end
    render json: { :data => @languages }

  end

  def find_id
    @language = Language.find_by_name(params[:language])
    render json: { data: @language }
  end 

end
