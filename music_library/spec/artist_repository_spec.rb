require 'artist_repository'

describe ArtistRepository do
    def reset_artists_table
        seed_sql = File.read('spec/seeds_artists.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
        connection.exec(seed_sql)
    end

    before(:each) do 
        reset_artists_table
    end
    
    it 'returns the list of artists' do
        repo = ArtistRepository.new

        artists = repo.all

        expect(artists.length).to eq 2
        expect(artists[0].id).to eq '1'
        expect(artists[0].name).to eq 'Pixies'
        expect(artists[0].genre).to eq 'Rock'
    end
    
    it 'returns the Pixies as single artist' do
        repo = ArtistRepository.new
        artist = repo.find(1)

        expect(artist.name).to eq 'Pixies'
        expect(artist.genre).to eq 'Rock'
    end

    it 'returns the ABBA as single artist' do
        repo = ArtistRepository.new
        artist = repo.find(2)

        expect(artist.name).to eq 'ABBA'
        expect(artist.genre).to eq 'Pop'
    end
end