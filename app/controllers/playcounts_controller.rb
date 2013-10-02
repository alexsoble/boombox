class PlaycountsController < ApplicationController

  def create
    @playcount = Playcount.create(user_id: params[:user_id], video_id: params[:video_id], play_count: 0)
    render :json => { :playcount_id => @playcount.id }
  end

  def find
    @playcount = Playcount.where(:user_id => params[:user_id], :video_id => params[:video_id]).first
    if @playcount.present?
      render :json => { :playcount_id => @playcount.id }
    else
      render :json => { :playcount_id => 'no-playcount' } 
    end
  end 

  def update
    @playcount = Playcount.find_by_id(params[:id])
    @playcount.play_count += 0.5
    @playcount.save
    render :json => { :play_count => @playcount.play_count }
  end
end
