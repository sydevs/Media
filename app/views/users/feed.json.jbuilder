
json.array! @features do |feature|
  json.header translate("featured.#{feature}.header")
  json.type :featured
  json.disabled false
  json.card do
    json.title translate("featured.#{feature}.title")
    json.subtitle translate("featured.#{feature}.subtitle")
    json.image_url image_url("thumbnails/#{feature}.jpg")
    json.link_type get_link_type(feature)
    json.link get_link(feature)
  end
end

json.array! @actions do |action|
  json.header translate("featured.#{action}.header")
  json.type :action
  json.disabled @features&.first == :realisation
  json.card do
    json.title translate("featured.#{action}.title")
    json.subtitle translate("featured.#{action}.subtitle")
    json.image_url image_url("thumbnails/#{action}.jpg")
    json.link_type get_link_type(action)
    json.link get_link(action)
  end
end

json.array! @categories do |category|
  if @user.respond_to?(category)
    meditations = @user.send(category).limit(10)
  else
    meditations = Meditation.tagged_with(category).reorder('RANDOM()').limit(4)
  end

  json.header translate("categories.#{category}")
  json.type :list
  json.disabled @features&.first == :realisation
  json.cards do
    json.array! meditations do |meditation|
      json.type :meditation
      json.title meditation.title
      json.image_url meditation.thumbnail_url
      json.url meditation_url(meditation, format: :json)
      json.duration meditation.duration
    end
  end
  
end
