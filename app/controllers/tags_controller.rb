class TagsController < ApplicationController

  def create
    @tag = Tag.new
    @tag.name = params[:name]
    @tag.video_id = params[:video_id]
    @tag.user_id = params[:user_id]

    @tag.type_lang = false
    @tag.type_style = false
    @tag.type_artist = false
    @tag.type_difficulty = false

    tag_type = params[:tag_type]
    if tag_type == 'language'
      @tag.type_lang = true
    elsif tag_type == 'style'
      @tag.type_style = true
    elsif tag_type == 'artist'
      @tag.type_artist = true
    elsif tag_type == 'difficulty'
      @tag.type_difficulty = true
    end

    @tag.save

    render :json => { :tag => @tag }
  end

end