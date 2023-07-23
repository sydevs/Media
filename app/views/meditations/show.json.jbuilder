
json.id @meditation.id
json.title @meditation.title
json.frames @meditation.keyframes.order(seconds: :asc) do |keyframe|
  frame = keyframe.frame

  json.id keyframe.frame_id
  json.seconds keyframe.seconds
  json.type frame.video? ? 'video' : 'image'
  json.frame frame.url
end
