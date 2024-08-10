class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent

  before_action :redirect_to_storyblok
  before_action -> {
    response.headers.delete('X-Frame-Options')
  }

  private

    def redirect_to_storyblok
      return unless params[:init_oauth]

      redirect_to 'https://app.storyblok.com/oauth/app_redirect', allow_other_host: true
    end

end
