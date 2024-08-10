class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent

  def storyblok
    redirect_to 'https://app.storyblok.com/oauth/app_redirect', allow_other_host: true
  end

end
