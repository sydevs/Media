class User < ApplicationRecord
  # has_recommended :meditations

  flag :seen, %i[realisation path music introspect map]
  flag :unlocked, %i[realisation footsoak lectures]

  has_many :meditation_views
  has_many :viewed_meditations, through: :meditation_views, source: :meditation
  has_many :user_meditations
  has_many :saved_meditations, through: :user_meditations, source: :meditation

  def track_action action
    meditation = Meditation.find(action['meditation_id']) if action['meditation_id'].present?

    case action.type
    when 'seen'
      seen.set action['flag']
    when 'unlock'
      unlocked.set action['flag']
    when 'save'
      saved_meditations << meditation
    when 'unsave'
      saved_meditations.delete(meditation)
    when 'view'
      mv = meditation_views.create
    when 'path'
      self.path_progress = action['progress']
      self.path_progressed_at = Time.now
    end
  end

end
