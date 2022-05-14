require 'httparty'

## BUBBLE API
# This concern wraps requests to the Bubble API

module BubbleApi

  def self.fetch_meditation meditation_id
    # "self." means that this is a class method, not an instance method.
    # Set up the parameters we need


    parameters = {
      id: meditation_id,
    }


    # Set the correct URL for the REST API
    # url = "https://app.sydevelopers.com/version-test/api/1.1/obj/Meditation/1644108823956x994255784581267500"
    # url = "https://app.sydevelopers.com/version-test/api/1.1/obj/Meditation%20Frame?Meditation=1644108823956x994255784581267500"

    url = "https://app.sydevelopers.com/version-test/api/1.1/obj/Meditation/1644109290070x892742463383404500"
    # id 1644108823956x994255784581267500
    # url  "https://wemeditate.bubbleapps.io/api?#{parameters.to_query}"

    # Then we make the request using the HTTParty library
    response = HTTParty.get(url, { headers: { 'Content-Type': 'application/json' }, log_level: :debug })
    # puts "#{url} - #{response.pretty_inspect}"

    # Here's an example of a POST request, if you need to do that instead
    # https://github.com/sydevs/Atlas/blob/d5a2dc7e90c2cfe4e1da91bb02871641b574daa0/app/controllers/concerns/messagebird_api.rb#L13

    # https://app.sydevelopers.com/version-test/api/1.1/obj/Meditation%20Frame?Meditation=1644108823956x994255784581267500

    # Do something with the response
    # puts 'hitesh6'
    # puts response
    # data = response["response"]["results"] 
    parsed_json = JSON.parse(response.body)
    puts parsed_json["response"]["Audio"]

    # data.each do |item|
    #   puts item["Image"]
    #   # puts item["category"]
    #   # puts item["id"]
    # end
    
    return parsed_json["response"]["Audio"]
  end

  def self.fetch_media media_id

    url = "https://app.sydevelopers.com/version-test/api/1.1/obj/Meditation%20Media"
    response = HTTParty.get(url, { headers: { 'Content-Type': 'application/json' }, log_level: :debug })
    parsed_json = JSON.parse(response.body)
    results = parsed_json["response"]
    i=0

    puts 'media id' + media_id
    puts results['results']

    results['results'].each do |media|
      # text = "Current number is: #{n[i]['results']['Meditation']}"
      # i++
      # puts 'reading media'
      puts '----------------'
      puts media['_id']
      puts media_id
      puts '----------------'
      if media['_id'] == media_id
        # puts "inside first if"
        if media["Type"] == "Image" 
          # puts media["Image"]
          return media["Image"]
        end
  
        if media["Type"]  == "Video"
          # puts media["Video"]
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
    
    results['results'].each do |frame|
      # puts 'reading frame'
      # puts frame['Meditation']
      if frame['Meditation'] == meditation_id
        related_media = fetch_media(frame["Media"])
        puts related_media
        puts frame["Timestamp"]
      end
    end
    end


end
