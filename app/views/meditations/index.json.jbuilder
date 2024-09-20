
json.array! @meditations do |meditation|
  json.uuid meditation.uuid
  json.title meditation.title
  json.url meditation_url(meditation.uuid, format: :json)
  json.embed_url meditation_url(meditation.uuid)
end
