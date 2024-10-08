=begin
frame_images = Dir.glob('app/assets/images/prototype/images/*.webp')
frame_images = frame_images.concat Dir.glob('app/assets/images/prototype/videos/*.webm')
frames = frame_images.each_with_index.map do |file, index|
  frame = Frame.find_by_id(index) || Frame.new
  filename = file.split('/').last
  parts = filename.split('.').first.split(', ')
  frame.title = parts[1]
  frame.tags = parts.drop(2)
  frame.media.attach(io: File.open(file), filename: filename)
  puts "Creating frame - #{filename}"
  frame.save!
  frame
end

music = Music.first || Music.new
music.title = "Sample Music"
music.audio.attach(io: File.open('app/assets/images/prototype/audio/music.mp3'), filename: 'music.mp3')

10.times.each do |index|
  meditation = Meditation.find_by_id(index) || Meditation.new
  meditation.title = "Meditation #{index}"
  meditation.audio.attach(io: File.open('app/assets/images/prototype/audio/audio.webm'), filename: 'audio.webm')
  meditation.music = music
  meditation.duration = 482
  meditation.keyframes.destroy_all
  meditation.tags = %w[morning afternoon evening short music].sample(3)

  puts "Creating meditation - #{meditation.title}"
  meditation.save!

  seconds = 0
  40.times.each do |index|
    frame = frames.sample
    meditation.keyframes.create!(frame: frames.sample, seconds: seconds)
    seconds += (frame.video? ? 6 : 3) + rand(5)
  end

  puts "Created #{meditation.keyframes.count} frames with duration #{seconds}"
end
=end
