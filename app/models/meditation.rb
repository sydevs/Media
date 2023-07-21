class Meditation < ApplicationRecord
  has_one_attached :thumbnail
  has_one_attached :audio
  
  has_many :keyframes, as: :media
  has_many :frames, -> { distinct }, through: :keyframes
end
