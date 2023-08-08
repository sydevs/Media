meditations = Meditation.published.reorder('RANDOM()')
meditations = meditations.tagged_with(@time) if @time != 'default'

return if meditations.count < 1

json.title translate(@time, scope: 'sections.boost')
json.cards do
  json.array! meditations do |meditation|
    json.type :meditation
    json.title meditation.title
    json.image_url meditation.thumbnail_url
    json.url meditation_url(meditation, format: :json)
    json.duration meditation.duration
  end
end
