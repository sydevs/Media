require 'oauth2'

class AuthController < ApplicationController

  skip_before_action :authenticate!
  before_action :set_client

  def connect
    if params[:space_id] != ENV.fetch('STORYBLOK_SPACE_ID')
      render status: :forbidden, text: "403 Forbidden"
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
    if (params[:state].present? && params[:state] != session[:state]) || params[:space_id] != ENV.fetch('STORYBLOK_SPACE_ID')
      render status: :forbidden, text: "403 Forbidden"
      return
    end

    access_token = @client.auth_code.get_token(params[:code], redirect_uri: callback_url)
    Setting.access_token = access_token.as_json
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
