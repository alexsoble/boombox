#encoding: utf-8

Interpretation.each do |i|
  if i.lines.present?
    @transcript = Transcript.create({user_id: i.user_id, video_id: i.video_id, interpretation_id: i.id})
    @transcript.save
    i.lines.each do |l|
      l.transcript_id = @transcript.id
      l.save
    end
  end
end

# Language.create([
#   {:name => "English" },
#   {:name => "Dutch"},
#   {:name => "Afrikaans"},
#   {:name => "Chinese (Mandarin)"},
#   {:name => "Cantonese"},
#   {:name => "Japanese"},
#   {:name => "Korean"},
#   {:name => "Vietnamese"},
#   {:name => "Thai"}, 
#   {:name => "Burmese"},
#   {:name => "Tagalog"},
#   {:name => "Hmong"},
#   {:name => "Khmer"},
#   {:name => "Lao"},
#   {:name => "French"},
#   {:name => "Spanish"},
#   {:name => "Italian"},
#   {:name => "Catalan"},
#   {:name => "Romanian"},
#   {:name => "Albanian"},
#   {:name => "Russian"},
#   {:name => "Polish"},
#   {:name => "Czech"},
#   {:name => "German"},
#   {:name => "Greek"},
#   {:name => "Welsh"},
#   {:name => "Norwegian"},
#   {:name => "Swedish"},
#   {:name => "Danish"},
#   {:name => "Finnish"},
#   {:name => "Icelandic"},
#   {:name => "Hebrew"},
#   {:name => "Arabic"},
#   {:name => "Persian"},
#   {:name => "Pashto"},
#   {:name => "Turkish"},
#   {:name => "Hindi"},
#   {:name => "Bengali"},
#   {:name => "Gujarati"},
#   {:name => "Punjabi"},
#   {:name => "Sindhi"},
#   {:name => "Urdu"},
#   {:name => "Marathi"},
#   {:name => "Telugu"},
#   {:name => "Tamil"},
#   {:name => "Sinhala"},
#   {:name => "Latin"},
#   {:name => "Swahili"},
#   {:name => "Yoruba"},
#   {:name => "Xhosa"},
#   {:name => "Amharic"},
#   {:name => "Javanese"},
#   {:name => "Malay"},
#   {:name => "Kazakh"},
#   {:name => "Tajik"},
#   {:name => "Tibetan"},
#   {:name => "Uyghur"},
#   {:name => "Uzbek"} ])
