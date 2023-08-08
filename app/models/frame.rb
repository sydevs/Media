class Frame < ApplicationRecord
  has_one_attached :male
  has_one_attached :female

  default_scope -> { order(updated_at: :desc) }

  def video?
    media&.filename&.extension == 'webm'
  end

  def media gender = :male
    gender == :female ? (female || male) : (male || female)
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
