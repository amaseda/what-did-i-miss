class AlbumsController < ApplicationController
  def index
    dates = Album.generate_dates
    pitchfork_data = Album.get_albums( dates )
    @albums = Album.get_spotify( pitchfork_data )
  end
end
