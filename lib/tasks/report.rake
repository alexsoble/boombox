task :report => :environment do

  session = GoogleDrive.login("asoble@gmail.com", "wheninrome613")

  report = session.spreadsheet_by_key("0Aolt_F9Ok6-BdDEyM1dKb3FtdUlrTDBkZnczMVRXYlE").worksheets[0]

  @todays_new_users = User.where("created_at >= ?", Time.mktime(Time.now.year, Time.now.month, Time.now.day)).all
  @todays_new_interps = Interpretation.where("created_at >= ?", Time.mktime(Time.now.year, Time.now.month, Time.now.day)).all

  report[2, 1] = "#{Time.now.year}"
  report[2, 2] = "#{Time.now.month}"
  report[2, 3] = "#{Time.now.day}"
  report[2, 4] = "#{@todays_new_users.length}"
  report[2, 5] = "#{User.all.length}"
  report[2, 6] = "#{@todays_new_interps.length}"
  report[2, 7] = "#{Interpretation.all.length}"
  report.save()

end 