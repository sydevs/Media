class FramesController < ApplicationController

  def index
    @frames = Frame.all
  end

  def edit
    @frame = Frame.find(params[:id])
  end

end
