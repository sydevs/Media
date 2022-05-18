class MeditationsController < ApplicationController

include BubbleApi

  def embed

    @client = Client.find_by_public_key(params[:api_key])
    return if !params[:api_key].present?
    raise ActionController::RoutingError.new('Not Found') if @client.nil?

    headers['X-FRAME-OPTIONS'] = "ALLOW ALL"
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
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
