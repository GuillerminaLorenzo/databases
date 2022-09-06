require_relative 'artist'

class ArtistRepository
    def all
     artists = []
     sql = 'SELECT id, name, genre FROM artists;'
     result = DatabaseConnection.exec_params(sql, [])

     result.each do |record|
      artist = Artist.new
      artist.id = record['id']
      artist.name = record['name']
      artist.genre = record['genre']
      artists << artist
     end
     artists
    end
  end