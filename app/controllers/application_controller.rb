class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent

  before_action -> {
    response.headers['X-FRAME-OPTIONS'] = 'ALLOWALL'
  }

end
