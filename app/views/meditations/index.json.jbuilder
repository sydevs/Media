
json.array! @meditations do |meditation|
  json.id meditation.id
  json.title meditation.title
  json.url meditation_url(meditation, format: :json)
  json.embed_url meditation_url(meditation)
end
