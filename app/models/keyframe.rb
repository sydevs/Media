class Keyframe < ApplicationRecord
  belongs_to :media, polymorphic: true
  belongs_to :frame

  delegate :image, to: :frame
end
