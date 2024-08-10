class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent

  before_action -> {
    response.headers['X-FRAME-OPTIONS'] = 'ALLOWALL'
  }

  def storyblok
    pp params
    redirect_to 'https://app.storyblok.com/oauth/app_redirect', allow_other_host: true
  end

end
