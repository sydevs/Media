class Music < ApplicationRecord
  has_one_attached :audio
  acts_as_taggable_on :tags
  validates_presence_of :title, :credit

  default_scope -> { order(updated_at: :desc) }

  after_create :create_in_storyblok
  after_update :sync_to_storyblok

  def duration
    result = audio&.metadata&.fetch(:duration, nil)
    result ? (result / 60).round : nil
  end

  def published
    true
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
      return unless %w[title published].any? { |col| previous_changes.keys.include?(col) }

      space_id = ENV.fetch('STORYBLOK_SPACE_ID')
      StoryblokApi.client.put("/spaces/#{space_id}/stories/#{storyblok_id}", {
        story: storyblok_data,
        publish: published ? 1 : 0,
        force_update: 1,
      })
    end

    def storyblok_data
      folder_id = 551014134 # "music-refs" folder
      {
          name: title,
          slug: title.parameterize, # Generate a slug from the title
          lang: 'en',
          parent_id: folder_id,
          content: {
            component: 'MusicRef',
            # data_url: Rails.application.routes.url_helpers.url_for([self, id: uuid, format: :json, host: 'https://media.sydevelopers.com']),
            external_uuid: id,
          },
        }
    end
end
