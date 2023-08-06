class Meditation < ApplicationRecord
  has_one_attached :thumbnail
  has_one_attached :audio
  belongs_to :music
  
  has_many :keyframes, as: :media
  has_many :frames, -> { distinct }, through: :keyframes

  accepts_nested_attributes_for :keyframes, allow_destroy: true

  default_scope -> { order(updated_at: :desc) }

  def keyframes_data
    keyframes.first(20).map do |kf|
      kf.as_json(only: %i[id frame_id seconds]).merge!({
        video: kf.frame.video?,
        url: kf.frame.media.url,
        title: kf.frame.title
      })
    end
  end
end
