require "securerandom"

class Meditation < ApplicationRecord
  has_one_attached :art
  has_one_attached :audio
  belongs_to :music, optional: true
  
  has_many :keyframes, as: :media
  has_many :frames, -> { distinct }, through: :keyframes

  accepts_nested_attributes_for :keyframes, allow_destroy: true
  acts_as_taggable_on :tags

  default_scope -> { order(updated_at: :desc) }
  scope :published, -> { where(published: true) }

  before_create -> { self.uuid = SecureRandom.hex(5) }

  def thumbnail_url
    image.present? ? image.url : ActionController::Base.helpers.image_url("thumbnails/placeholder.jpg")
  end

  def duration
    result = audio.metadata.fetch(:duration, nil)
    result ? (result / 60).round : nil
  end
end
