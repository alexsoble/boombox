class Line < ActiveRecord::Base
  attr_accessible :downvotes, :interpretation_id, :lang1, :lang2, :time, :upvotes, :duration
  belongs_to :interpretation

  def formatted_time
    time = self.time
    if time <= 9
      formatted_time = "00:0" + time.to_s
    elsif 9 < time <= 59
      formatted_time = "00:" + time.to_s
    end
    
    # if 60 <= time < 540
    #   if time%60 <= 9 then formatted_time = "0" + (time)/60 + ":0" + (time)%60 end
    #   if 9 < time%60 <= 59 then formatted_time = "0" + (time)/60 + ":" + (time)%60 end
    # end
    # if 540 <= time < 3600 
    #   if time%60 <= 9 then formatted_time = (time)/60 + ":0" + (time)%60 end
    #   if 9 < time%60 <= 59 then formatted_time = (time)/60 + ":" + (time)%60 end
    # end
    return formatted_time
  end

end
