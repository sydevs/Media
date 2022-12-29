
frame_images = Dir.glob('app/assets/images/prototype/keyframes/*.webp')
frames = frame_images.each_with_index.map do |image, index|
  frame = Frame.find_by_id(index) || Frame.new
  filename = image.split('/').last
  parts = filename.split('.').first.split(', ')
  frame.title = parts[1]
  frame.tags = parts.drop(2)
  frame.image.attach(io: File.open(image), filename: filename)
  puts "Creating frame - #{frame.title}"
  frame.save!
  frame
end

100.times.each do |index|
  meditation = Meditation.find_by_id(index) || Meditation.new
  meditation.title = "Meditation #{index}"
  meditation.audio.attach(io: File.open('app/assets/images/prototype/audio.mp3'), filename: 'audio.mp3')
  meditation.duration = 482
  meditation.keyframes.destroy_all

  puts "Creating meditation - #{meditation.title}"
  meditation.save!

  seconds = 0
  300.times.each do |index|
    meditation.keyframes.create!(frame: frames.sample, seconds: seconds)
    seconds += 3 + rand(5)
  end

  puts "Created #{meditation.keyframes.count} frames with duration #{seconds}"
end
