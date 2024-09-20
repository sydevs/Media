class Music < ApplicationRecord

  include StoryblokReference

  has_one_attached :audio
  acts_as_taggable_on :tags
  validates_presence_of :title, :credit

  default_scope -> { order(updated_at: :desc) }

  before_create -> { self.uuid = SecureRandom.hex(5) + id.to_s }

  def duration
    result = audio&.metadata&.fetch(:duration, nil)
    result ? (result / 60).round : nil
  end

  def published
    true
  end

  private

    def storyblok_data
      folder_id = 551014134 # "music-refs" folder
      {
          name: title,
          slug: "#{title.parameterize}-#{uuid}", # Generate a slug from the title and uuid
          lang: 'en',
          parent_id: folder_id,
          tag_list: tag_list,
          content: {
            component: 'MusicRef',
            data_url: Rails.application.routes.url_helpers.url_for([self, id: uuid, format: :json, host: 'https://media.sydevelopers.com']),
            external_uuid: uuid,
          },
        }
    end
end
