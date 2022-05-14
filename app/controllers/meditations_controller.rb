class MeditationsController < ApplicationController

include BubbleApi

  def embed
    # Do something to load data from Bubble's REST API
    @meditation_audio = BubbleApi.fetch_meditation(params[:id])
    # puts "yo"  

    # @meditation_audio = @meditation_audio
    # puts @meditation

    @testAudio = 'http://meditatenepal.org/guided/media/FirstMeditation.mp3'
    # @meditation = 'http://meditatenepal.org/guided/media/FirstMeditation.mp3'
    # The @ symbol, means that this variable is an instance variable.
    # In the case of a controller, this means the variable will be passed to the view.
    # puts 'frames'
    @frames = BubbleApi.fetch_frame(params[:id])


  end

end
