class FramesController < ApplicationController

  def index
    @frames = Frame.all
  end

  def new
    @frame = Frame.new
  end
  
  def create
    @frame = Frame.create(arguments)
    
    if @frame.save
      redirect_to frames_path, flash: { success: "Created frame successfully" }
    else
      render :new, status: 422
    end
  end

  def edit
    @frame = Frame.find(params[:id])
  end

  def update
    @frame = Frame.find(params[:id])

    if @frame.update(arguments)
      redirect_to frames_path, flash: { success: "Updated frame successfully" }
    else
      render :edit, status: 422
    end
  end

  private

    def arguments
      params.require(:frame).permit(:published, :title, :tags, :male, :female)
    end
end
