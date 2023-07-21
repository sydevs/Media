class Frame < ApplicationRecord
  has_one_attached :media
  serialize :tags, Array

  def video?
    media.filename&.extension == 'webm'
  end
end
