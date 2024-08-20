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
  after_create :create_in_storyblok
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

    def create_in_storyblok
      client_id = ENV.fetch('STORYBLOK_CLIENT_ID')
      client_secret = ENV.fetch('STORYBLOK_CLIENT_SECRET')
      space_id = ENV.fetch('STORYBLOK_SPACE_ID') # Ensure you have this environment variable set

      client = Storyblok::Client.new(oauth_token: 'MY_TOKEN')
      response = client.post("/spaces/#{space_id}/stories", {
        story: {
          name: self.title,
          slug: self.title.parameterize, # Generate a slug from the title
        },
        publish: 1 # Set to 1 to publish immediately
      })

      if response.status == 200
        # Handle success
        Rails.logger.info("Story created successfully: #{response.body}")
      else
        # Handle error
        Rails.logger.error("Failed to create story: #{response.body}")
      end

      # ApplicationController.helpers.url_for(self)
      # Within this class you can reference variables of the meditation model, just by calling their name.
      # Take a look at schema.rb to find out what columns are on the Meditation table
    end

    def sync_to_storyblok
      client_id = ENV.fetch('STORYBLOK_CLIENT_ID')
      client_secret = ENV.fetch('STORYBLOK_CLIENT_SECRET')
      client = OAuth2::Client.new(client_id, client_secret, {
        site: 'https://app.storyblok.com',
        auth_scheme: :request_body,
      })

      ApplicationController.helpers.url_for(self)
      # Within this class you can reference variables of the meditation model, just by calling their name.
      # Take a look at schema.rb to find out what columns are on the Meditation table
    end
end
