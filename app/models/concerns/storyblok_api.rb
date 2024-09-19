
module StoryblokApi

  BASE_URL = 'mapi.storyblok.com'
  
  def self.client
    @@storyblock_client ||= begin
      Storyblok::Client.new(oauth_token: ENV.fetch('STORYBLOK_ACCESS_TOKEN'), api_url: BASE_URL)
    end
  end

  def self.oauth_token
    @@token ||= begin
      client = OAuth2::Client.new(
        ENV.fetch('STORYBLOK_CLIENT_ID'),
        ENV.fetch('STORYBLOK_CLIENT_SECRET'),
        {
          site: "https://#{BASE_URL}",
          auth_scheme: :request_body,
        }
      )

      access_token = OAuth2::AccessToken.from_hash(client, Setting.access_token)
      if Time.at(access_token.expires_at) < Time.now
        access_token = access_token.refresh
        Setting.access_token = access_token.as_json
      end

      access_token.token
    end
  end

  private

    def self.space_id
      @@space_id ||= ENV.fetch('STORYBLOK_SPACE_ID')
    end

end