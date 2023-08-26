require "securerandom"

class Meditation < ApplicationRecord
  has_one_attached :art
  has_one_attached :audio
  
  has_many :keyframes, as: :media
  has_many :frames, -> { distinct }, through: :keyframes

  accepts_nested_attributes_for :keyframes, allow_destroy: true
  acts_as_taggable_on :tags
  enum narrator: %i[male female]

  default_scope -> { order(updated_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :search, ->(q) { where("title ILIKE ?", "%#{q}%") }

  validates_presence_of :audio, :title

  before_create -> { self.uuid = SecureRandom.hex(5) }

  def thumbnail_url
    if art.present?
      art.url
    elsif tag_list.include?('path')
      ActionController::Base.helpers.image_url("thumbnails/path.jpg")
    else
      ActionController::Base.helpers.image_url("thumbnails/placeholder.jpg")
    end
  end

  def musics
    return [] unless music_tag.present?
    
    Music.tagged_with(music_tag).reorder('RANDOM()').limit(3)
  end

  def duration
    result = audio.metadata.fetch(:duration, nil)
    result ? (result / 60).round : nil
  end
end
