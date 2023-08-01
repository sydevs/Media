class UsersController < ApplicationController

  def track
    params.require(%i[user_id meditation_id category])

    meditation = Meditation.find(params[:meditation_id])
    user = User.find_or_create_by!(external_id: params[:user_id])
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
