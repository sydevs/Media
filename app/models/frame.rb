class Frame < ApplicationRecord
  has_one_attached :media

  def video?
    media.filename&.extension == 'webm'
  end

  def thumbnail
    media.try(media.previewable? ? :preview : :variant, resize_to_fill: [150, 150])
  end
end
