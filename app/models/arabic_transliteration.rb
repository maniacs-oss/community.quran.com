class ArabicTransliteration < QuranApiRecord
  belongs_to :word, optional: true
  belongs_to :verse
  has_many :proof_read_comments, as: :resource
  has_paper_trail on: :update, ignore: [:created_at, :updated_at]

  delegate :location, to: :word
  
  def name
    text
  end
  
  def get_word
    
  end

  def text_simple
    word&.text_uthmani_simple
  end
end
