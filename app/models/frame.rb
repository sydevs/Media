class Frame < ApplicationRecord
  has_one_attached :male
  has_one_attached :female

  default_scope -> { order(updated_at: :desc) }

  def video?
    %w[webm mp4].include?(media&.filename&.extension)
  end

  def media gender = :male
    gender&.to_s == 'female' ? female : male
  end

  def thumbnail gender = :male
    file = media(gender)
    return file.url unless file.variable? || file.previewable?

    if file.previewable?
      file.preview resize_to_fill: [150, 150]
    else
      file.variant resize_to_fill: [150, 150]
    end
  end
end
