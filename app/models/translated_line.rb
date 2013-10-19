class TranslatedLine < ActiveRecord::Base
  attr_accessible :lang2, :line_id, :translation_id
  belongs_to :translation
  belongs_to :line
end
