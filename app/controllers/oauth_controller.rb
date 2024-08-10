require 'oauth2'

class OauthController < ApplicationController

  skip_before_action :redirect_to_storyblok

  def connect
    puts "OATH CONNECT"
    pp params
    client_id = ENV.fetch('STORYBLOK_CLIENT_ID')
    client_secret = ENV.fetch('STORYBLOK_CLIENT_SECRET')
    client = OAuth2::Client.new(client_id, client_secret, site: 'https://app.storyblok.com')
    redirect_to client.auth_code.authorize_url(redirect_uri: oauth_callback_url, scope: 'read_content write_content')
  end

  def callback
    puts "OATH CALLBACK"
    pp params
    access = client.auth_code.get_token(params[:code], redirect_uri: oauth_callback_url)
    response = access.get('/api/resource', params: {'query_foo' => 'bar'})
    pp response
  end
end
