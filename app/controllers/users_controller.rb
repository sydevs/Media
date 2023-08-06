class UsersController < ApplicationController

  def home
    @time = params[:time] || "default"

    if params[:format] != 'json'
      @sections = render_to_string(template: 'users/home.json.jbuilder')
    end
  end

  def track
    params.require(%i[id meditation_id category])

    meditation = Meditation.find(params[:meditation_id])
    user = User.find_or_create_by!(external_id: params[:id])
    action = user.actions.create!({
      category: params[:category],
      record_type: meditation.class.name,
      record_id: meditation.id,
      metadata: params[:metadata] || {},
    })

    render status: 200, json: {
      message: "Success!",
      tracked_action: action.as_json(only: %i[id category user_id record_type record_id metadata]),
    }
  end

end
