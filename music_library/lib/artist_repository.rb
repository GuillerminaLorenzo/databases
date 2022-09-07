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

    def find(id)
        sql = 'SELECT id, name, genre FROM artists WHERE id = $1;'
        params = [id]

        result = DatabaseConnection.exec_params(sql, params)
        record = result[0]

        artist = Artist.new
        artist.id = record['id']
        artist.name = record['name']
        artist.genre = record['genre']

      return artist
    end

    def create(artist)
        sql = 'INSERT INTO artists (name, genre) VALUES ($1, $2);'
        params = [artist.name, artist.genre]

        DatabaseConnection.exec_params(sql, params)
    end

    def delete(id)
        sql = 'DELETE FROM artists WHERE id = $1;'
        params = [id]
        
        DatabaseConnection.exec_params(sql, params)
    end

    def update(artist)
        sql = 'UPDATE artists SET name = $1, genre = $2 WHERE id = $3;'
        params = [artist.name, artist.genre, artist.id]

        DatabaseConnection.exec_params(sql, params)
    end
end
