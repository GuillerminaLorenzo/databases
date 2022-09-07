require 'albums_repository'


describe AlbumRepository do
    def reset_albums_table
        seed_sql = File.read('spec/seeds_albums.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
        connection.exec(seed_sql)
    end
    
    before(:each) do 
        reset_albums_table
    end

    it 'return two albums' do 
        repo = AlbumRepository.new

        albums = repo.all

        expect(albums.length).to eq 2

        expect(albums[0].title).to eq 'Bossanova'
        expect(albums[0].release_year).to eq '1999'
        expect(albums[0].artist_id).to eq '1'
    end

    it 'returns the single album Bossanova' do
        repo = AlbumRepository.new
        albums = repo.find(1)

        expect(albums.title).to eq 'Bossanova'
        expect(albums.release_year).to eq '1999'
        expect(albums.artist_id).to eq '1'
    end

    it 'returns the single album Surfer Rosa' do
        repo = AlbumRepository.new
        albums = repo.find(2)

        expect(albums.title).to eq 'Surfer Rosa'
        expect(albums.release_year).to eq '2001'
        expect(albums.artist_id).to eq '1'
    end

    it 'creates a new album' do
        repo = AlbumRepository.new

        album = Album.new
        album.title = 'Trompe le Monde'
        album.release_year = '1991'
        album.artist_id = '1'

        repo.create(album)

        all_albums = repo.all

        last_album = all_albums.last
        expect(last_album.title).to eq 'Trompe le Monde'
        expect(last_album.release_year).to eq '1991'
        expect(last_album.artist_id).to eq '1'
    end

    it 'deletes one artist' do
        repo = AlbumRepository.new

        repo.delete(1)

        albums = repo.all
        expect(albums.length).to eq 1
        expect(albums[0].id).to eq '2'
    end

    it 'updates one artist' do
        repo = AlbumRepository.new

        album = repo.find(1)

        album.title = 'cccc'
        album.release_year = '1990'
        album.artist_id = '2'

        repo.update(album)

        albums = repo.find(1)

        expect(album.title).to eq 'cccc'
        expect(album.release_year).to eq '1990'
        expect(album.artist_id).to eq '2'
    end
end