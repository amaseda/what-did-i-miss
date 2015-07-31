class AlbumsController < ApplicationController
  def index
    @album = Album.new
    @dates = @album.generate_dates
    pitchfork_data = @album.get_albums( @dates )
    spotify_data = @album.get_spotify( pitchfork_data )
  end
end
