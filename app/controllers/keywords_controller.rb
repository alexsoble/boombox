class KeywordsController < ApplicationController

  def create
    @keyword = Keyword.create(params[:keyword])
    render :json => { :data => @keyword }
  end

  def destroy
    @keyword = Interpretation.where(:interpretation_id => params[:keyword][:interpretation_id]).where(:word_text => params[:keyword][:word_text]).first
    @keyword_id = @keyword.id
    @keyword.destroy
    @keyword.save
    render :json => { :data => @keyword_id }
  end

end