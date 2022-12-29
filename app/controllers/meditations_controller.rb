class MeditationsController < ApplicationController
    
  def show
    @meditation = Meditation.eager_load(:keyframes, keyframes: :frame).find(params[:id])
  end

end
