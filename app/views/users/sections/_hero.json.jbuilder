meditation = Meditation.tagged_with("afternoon").published.first

json.title translate(@time, scope: 'sections.hero')
json.card do
  json.type :meditation
  json.title translate(@time, scope: 'cards.hero.title')
  json.subtitle translate('cards.hero.subtitle')
  json.image_url meditation.thumbnail_url
  json.url meditation_url(meditation, format: :json)
end
