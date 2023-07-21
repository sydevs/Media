class Frame < ApplicationRecord
  has_one_attached :media

  def video?
    media.filename&.extension == 'webm'
  end
end
