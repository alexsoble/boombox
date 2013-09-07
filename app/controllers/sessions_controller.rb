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

  def create_with_omniauth

    auth = request.env["omniauth.auth"]

    @interp = Interpretation.find_by_id(session[:interp_to_export_to_google])
    @video = @interp.video
    @translator = User.find_by_id(@interp.user_id)
    @lines = Line.where(:interpretation_id => @interp.id).sort { |a, b| a.time <=> b.time }

    tmp_file = Tempfile.new(Digest::MD5.hexdigest(rand(12).to_s))
    File.open(tmp_file, 'w') do |f|  
      f.puts "#{@video.title}"  
      f.puts "\n"  
      f.puts "Translated from #{@video.lang1} by #{@translator.username}" 
      f.puts "\n"  
      f.puts "#{@video.lang1.upcase}"  
      @lines.each do |l|
        f.puts l.lang1  
      end
      f.puts "\n"  
      f.puts "#{@interp.lang2.upcase}"  
      @lines.each do |l|
        f.puts l.lang2
      end
    end  
    session = GoogleDrive.login_with_oauth(auth.credentials.token)

    if @translator.firstname.present?
      session.upload_from_file(tmp_file, "#{@video.title} - translation by #{@translator.firstname}.txt", :convert => true)
    elsif @translator.username.present?
      session.upload_from_file(tmp_file, "#{@video.title} - translation by #{@translator.username}.txt", :convert => true)
    end

    redirect_to interpretation_url(@interp)
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end

end