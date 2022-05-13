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

    url = "https://app.sydevelopers.com/version-test/api/1.1/obj/Meditation%20Media"
    # id 1644108823956x994255784581267500
    # url  "https://wemeditate.bubbleapps.io/api?#{parameters.to_query}"

    # Then we make the request using the HTTParty library
    response = HTTParty.get(url, { headers: { 'Content-Type': 'application/json' }, log_level: :debug })
    # puts "#{url} - #{response.pretty_inspect}"

    # Here's an example of a POST request, if you need to do that instead
    # https://github.com/sydevs/Atlas/blob/d5a2dc7e90c2cfe4e1da91bb02871641b574daa0/app/controllers/concerns/messagebird_api.rb#L13

    # Do something with the response
    # puts 'hitesh6'
    # puts response
    data = response["response"]["results"] 
    # puts response["response"]["results"]
    # data.each do |item|
    #   puts item["Image"]
    #   # puts item["category"]
    #   # puts item["id"]
    # end
    
    # return data
  end

end
