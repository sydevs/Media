class Music < ApplicationRecord
  has_one_attached :audio
  acts_as_taggable_on :tags
  validates_presence_of :title, :credit

  def duration
    result = audio&.metadata&.fetch(:duration, nil)
    result ? (result / 60).round : nil
  end
end
