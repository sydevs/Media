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
      space_id = ENV.fetch('STORYBLOK_SPACE_ID')
      response = StoryblokApi.client.post("/spaces/#{space_id}/stories", {
        story: storyblok_data,
        publish: published ? 1 : 0,
      })

      if new_record?
        self.storyblok_id = response['data']['story']['id']
      else
        update_column :storyblok_id, response['data']['story']['id']
      end
    end

    def sync_to_storyblok
      create_in_storyblok && return unless storyblok_id.present?
      return unless %w[title uuid locale published].any? { |col| previous_changes.keys.include?(col) }

      space_id = ENV.fetch('STORYBLOK_SPACE_ID')
      StoryblokApi.client.put("/spaces/#{space_id}/stories/#{storyblok_id}", {
        story: storyblok_data,
        publish: published ? 1 : 0,
        force_update: 1,
      })
    end

    def storyblok_data
      folder_id = 551014073 # "meditation-refs" folder
      {
          name: title,
          slug: title.parameterize, # Generate a slug from the title
          lang: 'en',
          parent_id: folder_id,
          content: {
            component: 'MeditationRef',
            data_url: Rails.application.routes.url_helpers.url_for([self, id: uuid, format: :json, host: 'https://media.sydevelopers.com']),
            external_uuid: uuid,
            locale: 'default',
          },
        }
    end
end
