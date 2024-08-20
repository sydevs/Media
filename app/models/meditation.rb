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
  after_update :sync_to_storyblok

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

  private

    def sync_to_storyblok
      client_id = ENV.fetch('STORYBLOK_CLIENT_ID')
      client_secret = ENV.fetch('STORYBLOK_CLIENT_SECRET')
      client = OAuth2::Client.new(client_id, client_secret, {
        site: 'https://app.storyblok.com',
        auth_scheme: :request_body,
      })

      # Within this class you can reference variables of the meditation model, just by calling their name.
      # Take a look at schema.rb to find out what columns are on the Meditation table
    end
end
