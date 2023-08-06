class Meditation < ApplicationRecord
  has_one_attached :thumbnail
  has_one_attached :audio
  belongs_to :music
  
  has_many :keyframes, as: :media
  has_many :frames, -> { distinct }, through: :keyframes

  accepts_nested_attributes_for :keyframes, allow_destroy: true

  default_scope -> { order(updated_at: :desc) }

  def duration
    audio.metadata.fetch(:duration, nil)
  end
end
