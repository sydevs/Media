class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent

  before_action -> {
    response.headers.delete('X-Frame-Options')
  }

end
