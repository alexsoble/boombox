class PlaycountsController < ApplicationController

  def create
    @playcount = Playcount.create(user_id: params[:user_id], video_id: params[:video_id], play_count: 0)
    render :json => { :data => @playcount }
  end

  def find
    @playcount = Playcount.where(:user_id => params[:user_id], :video_id => params[:video_id]).first
    if @playcount.present?
      render :json => { :data => @playcount }
    else
      render :json => { :data => 'no-playcount' } 
    end
  end 

  def update
    @playcount = Playcount.find_by_id(params[:id])
    @playcount.play_count += 1
    @playcount.save
    render :json => { :data => @playcount }
  end
  
end
