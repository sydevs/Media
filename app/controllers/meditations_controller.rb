class MeditationsController < ApplicationController
  after_action :allow_iframe, only: :show
  layout "embed", only: %i[show]

  def index
    @meditations = Meditation.all
  end

  def show
    @meditation = Meditation.eager_load(:keyframes, :frames).find(params[:id])
    @keyframes = @meditation.keyframes.as_json(only: %i[id frame_id seconds])
    @preload_count = 5
  end

  def new
    @meditation = Meditation.new
  end
  
  def create
    @meditation = Meditation.find(params[:id])
    
    if @meditation.save(arguments)
      redirect_to recut_meditation_path(@meditation), flash: { success: "Created meditation successfully" }
    else
      render :new
    end
  end

  def edit
    @meditation = Meditation.find(params[:id])
  end

  def recut
    @meditation = Meditation.find(params[:id])
    @frames_json = Frame.all.map do |f|
      f.as_json(only: %i[id title]).merge!({
        video: f.video?,
        url: f.media.url,
        #subtitle: f.tags,
      })
    end.to_json
  end
  
  def update
    @meditation = Meditation.find(params[:id])

    if @meditation.update(arguments)
      redirect_to meditations_path, flash: { success: "Updated meditation successfully" }
    else
      render :edit
    end
  end

  private

    def allow_iframe
      response.headers.except! 'X-Frame-Options'
      response.headers['Access-Control-Allow-Methods'] = 'GET'
      response.headers['Access-Control-Request-Method'] = '*'
      response.headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end

    def arguments
      if action_name == 'recut'
        params.require(:meditation).permit(:keyframes)
      else
        params.require(:meditation).permit(:title, :thumbnail)
      end
    end

end
