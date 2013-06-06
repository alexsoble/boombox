class UsersController < ApplicationController

  def new

  end 

  def index
 
    @top_ten_users = User.limit(10)

  end

  def show

    @interpretations = interpretation.where(:user_id => @current_user.id).order("created_at ASC")

  end
  
end
