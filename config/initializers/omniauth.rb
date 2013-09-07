Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV["TWITTER_KEY"], ENV["TWITTER_SECRET"]
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider OmniAuth::Strategies::GoogleOauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {
      :name => "google",
      :scope => "userinfo.profile, drive.file, https://docs.google.com/feeds/, http://docs.googleusercontent.com/",
      :prompt => "select_account",
    }
end