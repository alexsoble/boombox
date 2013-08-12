class SessionsController < ApplicationController
  
def create
  user = User.find_by_username(params[:name])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect_to root_url, notice: "Signed in!"
  else
    flash.now.alert = "Sorry, e-mail or password is invalid. :("
    render "new"
  end
end

def destroy
  session[:user_id] = nil
  redirect_to root_url, notice: "Logged out!"
end

  # FOR TWITTER WITH OMNIAUTH -- TO COME LATER
  # def create
  #   user = User.from_omniauth(env["omniauth.auth"])
  #   session[:user_id] = user.id
  #   redirect_to root_url, notice: "Signed in!"
  # end
  # def destroy
  #   session[:user_id] = nil
  #   redirect_to root_url, notice: "Signed out!"
  # end

end
