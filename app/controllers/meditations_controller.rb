class MeditationsController < ApplicationController
  after_action :allow_iframe, only: %i[show tagged]
  layout "embed", only: %i[show tagged]

  def index
    core_tags = %w[morning afternoon evening path]
    
    if params[:tag]
      if params[:tag] == 'other'
        @meditations = Meditation.tagged_with(core_tags, exclude: true)
      elsif params[:tag] == 'incomplete'
        @meditations = Meditation.where(published: false)
      else
        @meditations = Meditation.tagged_with(params[:tag])
      end
    else
      @meditations = Meditation.default_scoped
    end

    @meditations = @meditations.search(params[:q]) if params[:q].present?
    @meditations = @meditations.limit(50)
    @tags = core_tags + %w[other incomplete]
  end

  def show
    @meditation = Meditation.eager_load(:keyframes, :frames).find_by!(uuid: params[:id])
    @keyframes = @meditation.keyframes.as_json(only: %i[id frame_id seconds])
    @preload_count = 5
  end

  def tagged
    #@meditation = Meditation.published.eager_load(:keyframes, :frames).tagged_with(params[:tag]).reorder('RANDOM()').first
    tags = [params[:tag]] + (params[:with]&.split(',') || [])
    meditations = Meditation.tagged_with(tags).eager_load(:keyframes, :frames)
    meditations = meditations.tagged_with(params[:without].split(','), exclude: true) if params[:without].present?
    @meditation = meditations.reorder('RANDOM()').first
    throw ActiveRecord::RecordNotFound if @meditation.nil?

    @keyframes = @meditation.keyframes.as_json(only: %i[id frame_id seconds])
    @preload_count = 5

    render 'show'
  end

  def new
    @meditation = Meditation.new(music_tag: 'default')
  end
  
  def create
    @meditation = Meditation.create(arguments)
    
    if @meditation.save
      @meditation.keyframes.create!(seconds: 0, frame_id: Frame.where(category: "ready").first.id)
      redirect_to recut_meditation_path(@meditation), flash: { success: "Created meditation successfully" }
    else
      render :new, status: 422
    end
  end

  def edit
    @meditation = Meditation.find(params[:id])
  end

  def recut
    @meditation = Meditation.find(params[:id])
    @meditation_json = {
      published: @meditation.published,
      audio: {
        filename: @meditation.audio.filename,
        url: @meditation.audio.url,
      },
      keyframes: @meditation.keyframes.first(20).map do |kf|
        kf.as_json(only: %i[id frame_id seconds]).merge!({
          video: kf.frame.video?,
          url: kf.frame.media(@meditation.narrator).url,
          thumbnail_url: url_for(kf.frame.thumbnail(@meditation.narrator)),
          title: kf.frame.category,
          subtitle: kf.frame.tags,
        })
      end,
    }

    @frames_json = Frame.all.map do |f|
      f.as_json(only: %i[id category]).merge!({
        video: f.video?,
        url: f.media(@meditation.narrator).url,
        thumbnail_url: url_for(f.thumbnail(@meditation.narrator)),
        subtitle: f.tags,
      })
    end
  end
  
  def update
    @meditation = Meditation.find(params[:id])

    if @meditation.update(arguments)
      redirect_to meditations_path, flash: { success: "Updated meditation successfully" }
    else
      render :edit, status: 422
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
      params.require(:meditation).permit(:published, :title, :art, :tag_list, :audio, :narrator, :music_tag, keyframes_attributes: %i[id frame_id seconds _destroy])
    end

end
