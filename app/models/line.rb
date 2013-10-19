class Line < ActiveRecord::Base
  attr_accessible :transcript_id, :interpretation_id, :lang1, :lang2, :time, :duration, :video_id
  belongs_to :transcript
  belongs_to :interpretation
  belongs_to :video
  has_many :comments
  has_many :translations

  def formatted_time

    time = self.time

    if time <= 9
      formatted_time = "00:0" + time.to_s
    elsif 9 < time && time <= 59
      formatted_time = "00:" + time.to_s
    elsif 60 <= time && time < 540
      if time%60 <= 9
       formatted_time = "0" + ((time)/60).to_s + ":0" + ((time)%60).to_s
      elsif 9 < time%60 && time%60 <= 59 
       formatted_time = "0" + ((time)/60).to_s + ":" + ((time)%60).to_s 
     end
    elsif 540 <= time && time < 3600 
      if time%60 <= 9 then formatted_time = (time)/60 + ":0" + (time)%60 end
      if 9 < time%60 && time%60 <= 59 then formatted_time = (time)/60 + ":" + (time)%60 end
    end
    return formatted_time

  end

  def formatted_end_time

    time = self.time + self.duration

    if time <= 9
      formatted_time = "00:0" + time.to_s
    elsif 9 < time && time <= 59
      formatted_time = "00:" + time.to_s
    elsif 60 <= time && time < 540
      if time%60 <= 9
       formatted_time = "0" + ((time)/60).to_s + ":0" + ((time)%60).to_s
      elsif 9 < time%60 && time%60 <= 59 
       formatted_time = "0" + ((time)/60).to_s + ":" + ((time)%60).to_s 
     end
    elsif 540 <= time && time < 3600 
      if time%60 <= 9 then formatted_time = (time)/60 + ":0" + (time)%60 end
      if 9 < time%60 && time%60 <= 59 then formatted_time = (time)/60 + ":" + (time)%60 end
    end
    return formatted_time

  end


end
