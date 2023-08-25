class FramesController < ApplicationController

  def index
    core_names = %w[mooladhara swadhistan nabhi heart vishuddhi agnya sahasrara]

    if params[:tag]
      if params[:tag] == "other"
        @frames = Frame.where.not(category: core_names)
      else
        @frames = Frame.where(category: params[:tag])
      end
    else
      @frames = Frame.default_scoped
    end

    @frames = @frames.search(params[:q]) if params[:q].present?
    @tags = core_names + %w[other]
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
      params.require(:frame).permit(:published, :category, :tags, :male, :female)
    end
end
