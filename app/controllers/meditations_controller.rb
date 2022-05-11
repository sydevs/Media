class MeditationsController < ApplicationController

  def embed
    # Do something to load data from Bubble's REST API
    #@meditation = BubbleAPI.fetch_meditation(params[:id])
    @meditation = 'http://meditatenepal.org/guided/media/FirstMeditation.mp3'
    # The @ symbol, means that this variable is an instance variable.
    # In the case of a controller, this means the variable will be passed to the view.
  end

end
