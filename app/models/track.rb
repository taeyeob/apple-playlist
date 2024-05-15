class Track < ApplicationRecord

  def find_song_by_isrc
    developer_token = ENV["APPLE_MUSIC_DEVELOPER_TOKEN"]
    headers = {
      "Authorization" => "Bearer #{developer_token}"
    }
  
    response = HTTParty.get("https://api.music.apple.com/v1/catalog/us/songs?filter[isrc]=#{isrc}", headers: headers)
    if response.success?
      return response.parsed_response
    else
      raise "Failed to fetch song by ISRC: #{response.body}"
    end
  end
  
end
