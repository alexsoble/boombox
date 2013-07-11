require 'net/http'
require 'rexml/document'

class PagesController < ApplicationController

  def philosophy 
  end 
  
  def survey
  end

  def help
  end
  
  def experiment
  end

  def read_data_from_youtube

    @xml = params[:youtube_data]

    doc = REXML::Document.new(@xml)
    @titles = []

    doc.elements.each do |ele|
       @titles << ele.title
    end

    render :json => { :results => @titles }

  end

end
