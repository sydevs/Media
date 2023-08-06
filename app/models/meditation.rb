class Meditation < ApplicationRecord
  has_one_attached :thumbnail
  has_one_attached :audio
  belongs_to :music
  
  has_many :keyframes, as: :media
  has_many :frames, -> { distinct }, through: :keyframes

  accepts_nested_attributes_for :keyframes, allow_destroy: true
  acts_as_taggable_on :tags

  default_scope -> { order(updated_at: :desc) }
  scope :published, -> { where(published: true) }

  def duration
    audio.metadata.fetch(:duration, nil)
  end
end
