class MeditationsController < ApplicationController
  after_action :allow_iframe, only: :show
    
  def show

    @meditation = Meditation.eager_load(:keyframes, :frames).find(params[:id])
    @keyframes = @meditation.keyframes.as_json(only: %i[id frame_id seconds])
    @preload_count = 5
  end

  private

    def allow_iframe
      response.headers.except! 'X-Frame-Options'
      response.headers['Access-Control-Allow-Methods'] = 'GET'
      response.headers['Access-Control-Request-Method'] = '*'
      response.headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end

end
