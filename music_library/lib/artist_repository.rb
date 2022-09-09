require_relative './artist'
require_relative './albums'


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

    def find_with_albums(artist_id)
        sql = 'SELECT artists.id AS "id",
                    artists.name AS "name",
                    artists.genre AS "genre",
                    albums.id AS "album_id",
                    albums.title AS "title",
                    albums.release_year AS "release_year"
                FROM artists
                    JOIN albums 
                    ON albums.artist_id = artists.id
                WHERE artists.id = $1;'
                    
        params = [artist_id]
        result = DatabaseConnection.exec_params(sql, params)

        first_record = result[0]
        artist = record_to_artist_object(first_record)

        result.each do |record|
            artist.albums << record_to_album_object(record)
        end
    artist
    end

    private

    def record_to_artist_object(record)
        artist = Artist.new
        artist.id = record['id']
        artist.name = record['name']
        artist.genre = record['genre']
    
        return artist
    end

    def record_to_album_object(record)
        album = Album.new
        album.id = record['album_id']
        album.title = record['title']
        album.release_year = record['release_year']

        return album
    end

end
