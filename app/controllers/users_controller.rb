class UsersController < ApplicationController

  def feed
    @user = User.find_or_create_by!(external_id: params[:id])
    @datetime = DateTime.parse(params[:time])
    puts @user
    puts params[:time]
    puts @datetime

    if @datetime.nil?
      @time_of_day = :daily
    elsif @datetime.hour <= 11
      @time_of_day = :morning
    elsif @datetime.hour >= 17
      @time_of_day = :evening
    else
      @time_of_day = :afternoon
    end

    @features = feature_sections
    @actions = action_sections
    @categories = category_sections

    if params[:format] != 'json'
      @sections = render_to_string('users/home', format: :json, layout: false)
    end
  end

  def track
    params.require(%i[external_id actions])

    user = User.find_or_create_by!(external_id: params[:id])
    params[:actions].each do |action|
      user.track_action(action)
    end

    user.save!

    render status: 200, json: {
      status: 200,
      message: "Success!",
      data: user.as_json(only: %i[id seen unlocked path_progress path_progressed_at]),
    }
  end

  def parameters
    return unless params[:type]
    data = translate("users.#{params[:type]}")
    render json: data.to_a.map! { |p| { name: p.last, value: p.first } }
  end

  private

    def feature_sections
      return %i[realisation] if !@user.unlocked.realisation?

      features = []
      features << :live if @datetime.utc.hour == 6 # 6 - 7pm in the UK
      features << @time_of_day
      features
    end

    def action_sections
      actions = []

      if @user.path_progress == 0
        actions << :start_path
      elsif (Time.now - @user.path_progressed_at) > 3.days
        actions << :continue_path
      end
      
      if @user.path_progress > 20
        actions << :map
      elsif @user.path_progress > 10
        actions << :music
      end

      actions
    end

    def category_sections
      categories = []

      # Show quick meditations on Monday - Friday mornngs, otherwise time of day meditations
      if @time_of_day == :morning && 1 <= @datetime.wday <= 5
        categories << :short
      else
        categories << @time_of_day
      end
    
      # Show recommendations if user has viewed at least 20 meditations
      if @user.meditation_views.count > 20
        # categories << :recommended_meditations
      end
    
      # Show music-based meditations on weekends.
      if @datetime.wday == 0 || @datetime.wday == 6
        categories << :musical
      end
    
      # Show recommendations if user has viewed at least 20 meditations
      if @user.saved_meditations.count > 0
        categories << :saved_meditations
      end

      categories
    end

end
