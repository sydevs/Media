
json.uuid @music.uuid
json.title @music.title
json.duration @music.duration
json.credit @music.credit
json.tags @music.tags.map(&:name)
json.audio_url @music.audio&.url
