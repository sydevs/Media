class MeditationsController < ApplicationController
    
  def show
    @meditation = Meditation.eager_load(:keyframes, :frames).find(params[:id])
    @keyframes = @meditation.keyframes.as_json(only: %i[id frame_id seconds])
    @preload_count = 5
  end

end
