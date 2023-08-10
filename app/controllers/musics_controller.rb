class MusicsController < ApplicationController

  def index
    @musics = Music.all
  end

  def new
    @music = Music.new
  end
  
  def create
    @music = Music.create(arguments)
    
    if @music.save
      redirect_to musics_path, flash: { success: "Created music successfully" }
    else
      render :new, status: 422
    end
  end

  def edit
    @music = Music.find(params[:id])
  end

  def update
    @music = Music.find(params[:id])

    if @music.update(arguments)
      redirect_to musics_path, flash: { success: "Updated music successfully" }
    else
      render :edit, status: 422
    end
  end

  private

    def arguments
      params.require(:music).permit(:title, :credit, :tag_list, :audio)
    end
end
