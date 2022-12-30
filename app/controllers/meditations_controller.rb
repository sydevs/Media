class MeditationsController < ApplicationController
    
  def show
    @meditation = Meditation.eager_load(:keyframes, :frames).find(params[:id])
    @preload_count = 5
    @keyframes = @meditation.keyframes.as_json(only: %i[id frame_id seconds])
    @frames = @meditation.frames.map do |frame|
      {
        id: frame.id,
        url: helpers.image_url("prototype/images/#{frame.image.filename}"), # helpers.url_for(frame.image)
      }
    end
  end

end
