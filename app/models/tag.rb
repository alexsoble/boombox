class Tag < ActiveRecord::Base
  attr_accessible :name, :type_artist, :type_difficulty, :type_lang, :type_style, :user_id, :video_id

  def category

    if self.type_artist == true
      return "artist"
    elsif self.type_difficulty == true
      return "difficulty"
    elsif self.type_lang == true
      return "language"
    elsif self.type_style == true
      return "style"
    else
      return ""
    end

  end

  has_many :tag_votes

end
