
module StoryblokReference
  
  extend ActiveSupport::Concern

  included do
    after_create :create_in_storyblok
    after_update :sync_to_storyblok
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
      return unless %w[title uuid locale published tags].any? { |col| previous_changes.keys.include?(col) }

      space_id = ENV.fetch('STORYBLOK_SPACE_ID')
      StoryblokApi.client.put("/spaces/#{space_id}/stories/#{storyblok_id}", {
        story: storyblok_data,
        publish: published ? 1 : 0,
        force_update: 1,
      })
    rescue RestClient::NotFound
      create_in_storyblok
    end

end