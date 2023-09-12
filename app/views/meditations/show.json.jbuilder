
json.id @meditation.id
json.title @meditation.title
json.tags @meditation.tags.map(&:name)
json.audio_url @meditation.audio&.url

json.musics @meditation.musics do |music|
  json.title music.title
  json.credit music.credit
  json.url music.audio.url
end

json.frames @meditation.keyframes.order(seconds: :asc) do |keyframe|
  frame = keyframe.frame

  json.id keyframe.frame_id
  json.seconds keyframe.seconds
  json.type frame.video? ? 'video' : 'image'
  json.frame frame.media(@meditation.narrator).url
end
