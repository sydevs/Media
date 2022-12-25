require 'httparty'

## BUBBLE API
# This concern wraps requests to the Bubble API

module BubbleApi

  def self.fetch_meditation meditation_id
    url = "https://app.sydevelopers.com/version-test/api/1.1/obj/Meditation/" + meditation_id
    response = HTTParty.get(url, { headers: { 'Content-Type': 'application/json' }, log_level: :debug })
    parsed_json = JSON.parse(response.body)
    return parsed_json["response"]["Audio"]
  end

  def self.fetch_media media_id
    url = "https://app.sydevelopers.com/version-test/api/1.1/obj/Meditation%20Media"
    response = HTTParty.get(url, { headers: { 'Content-Type': 'application/json' }, log_level: :debug })
    parsed_json = JSON.parse(response.body)
    results = parsed_json["response"]

    results['results'].each do |media|
      if media['_id'] == media_id
        if media["Type"] == "Image" 
          return media["Image"]
        end
  
        if media["Type"]  == "Video"
          return media["Video"]
        end

      end
    end
  end


  def self.fetch_frame meditation_id
    url = "https://app.sydevelopers.com/version-test/api/1.1/obj/Meditation%20Frame"
    response = HTTParty.get(url, { headers: { 'Content-Type': 'application/json' }, log_level: :debug })
    parsed_json = JSON.parse(response.body)
    results = parsed_json["response"]
    
    mediaArray = Array.new

    results['results'].each do |frame|
      if frame['Meditation'] == meditation_id
        related_media = fetch_media(frame["Media"])
        mediaArray.push([related_media, frame["Timestamp"]])
      end
    end
  
    return mediaArray
  end

end