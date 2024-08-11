require 'oauth2'

class AuthController < ApplicationController

  before_action :set_client

  def connect
    puts "OAUTH CONNECT"
    pp params
    
    if params[:space_id] != ENV.fetch('STORYBLOK_SPACE_ID')
      head :forbidden
      return
    end

    if session[:storyblok_token]
      redirect_to 'https://app.storyblok.com/oauth/app_redirect', allow_other_host: true
    else
      session[:state] = SecureRandom.hex

      url = @client.auth_code.authorize_url({
        response_type: 'code',
        redirect_uri: callback_url,
        scope: 'read_content write_content',
        state: session[:state],
      })

      redirect_to url, allow_other_host: true
    end
  end

  def callback
    puts "OAUTH CALLBACK"
    pp params
    if params[:state] != session[:state] || params[:space_id] != ENV.fetch('STORYBLOK_SPACE_ID')
      head :forbidden
      return
    end

    access_token = @client.auth_code.get_token(params[:code], redirect_uri: callback_url)
    pp access_token

    redirect_to 'https://app.storyblok.com/oauth/app_redirect', allow_other_host: true
  end

  private

    def set_client
      client_id = ENV.fetch('STORYBLOK_CLIENT_ID')
      client_secret = ENV.fetch('STORYBLOK_CLIENT_SECRET')
      @client = OAuth2::Client.new(client_id, client_secret, {
        site: 'https://app.storyblok.com',
        auth_scheme: :request_body,
      })
    end

end
