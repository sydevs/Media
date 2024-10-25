class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent

  before_action :authenticate!
  before_action -> {
    response.headers.delete('X-Frame-Options')
  }
  
  private

    def authenticate!
      if session[:is_admin].nil?
        session[:is_admin] = params[:user_is_admin] ? params[:user_is_admin] == 'true' : false
      end

      #if params[:space_id] != ENV.fetch('STORYBLOK_SPACE_ID') || params[:slug] != ENV.fetch('STORYBLOK_SLUG')
      #  render status: :forbidden, text: "403 Forbidden"
      #els
      if Setting.access_token == nil && params[:init_oauth] == "true"
        redirect_to connect_path(request.query_parameters)
      elsif Setting.access_token == nil
        head :forbidden
      end
    end

end
