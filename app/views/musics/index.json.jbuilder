
json.array! @musics do |music|
  json.uuid music.uuid
  json.title music.title
  json.url music_url(music.uuid, format: :json)
end
