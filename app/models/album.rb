class Album < ActiveRecord::Base

  # Returns with dates for the past week
  def generate_dates
    dates = []
    today = Time.new
    7.times do
      today -= 86400
      dates << today.to_s[0..9]
    end
    return dates
  end

  # Returns albums (artist, album title) released over the past week.
  # Only includes albums that receive a P4K score greater than 7.0.
  def get_albums( dates )
    results = []
    7.times do |i|
      response = JSON.parse( HTTParty.get( "http://www.pitchforkmetrics.com/reviews/single-day?date=#{dates[i]}" ).body )
      response.each do |album|
        if album["score"] >= 7.0
          release = {
            "artist" => album["artist"],
            "album" => album["album"]
          }
          results << release
        end
      end
    end
    return results
  end

  # Return Spotify album embed codes
  # Pulls first album from response
  def get_spotify( albums )
    results = []
    albums.each do |album|
      album["artist"].gsub!(" ", "%20")
      album["album"].gsub!(" ", "%20")
      response = JSON.parse( HTTParty.get( "https://api.spotify.com/v1/search?q=artist:#{album["album"]}%20artist:#{album["artist"]}&type=album" ).body["albums"] )
      if response["items"].length > 0
        release = {
          "artist" => album["items"]["album"],
          "album" => response["items"][0]["name"],
          "album_id" => response["items"][0]["id"]
        }
        release << results
      end
    end
    return results
  end
end
