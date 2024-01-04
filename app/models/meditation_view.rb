class MeditationView < ApplicationRecord
  belongs_to :user
  belongs_to :meditation

  def self.view_recommendation_data
    map { |v| { user_id: user_id, item_id: meditation_id }}
  end

  def self.rating_recommendation_data
    map { |v| { user_id: user_id, item_id: meditation_id, rating: rating }}
  end

  def self.progress_recommendation_data
    map { |v| { user_id: user_id, item_id: meditation_id, rating: progress }}
  end
end
