class Frame < ApplicationRecord
  has_one_attached :male
  has_one_attached :female

  has_many :keyframes

  default_scope -> { order(category: :asc, tags: :asc) }
  scope :search, ->(q) { where("category ILIKE ?", "%#{q}%") }

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
