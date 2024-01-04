module FeedHelper

  LINKS = {
    realisation: %w[app FirstMeditationInvite],
    daily: %w[app GoalSelection],
    morning: %w[app GoalSelection],
    afternoon: %w[app GoalSelection],
    evening: %w[app GoalSelection],
    start_path: %w[app PathStoryExplainer],
    continue_path: %w[app Path],
    music: %w[app MusicPage],
    map: %w[web https://wemeditate.com/map],
    live: %w[web https://wemeditate.com/live],
  }

  def get_link_type slug
    LINKS[slug][0]
  end

  def get_link slug
    LINKS[slug][1]
  end

end
