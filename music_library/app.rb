require_relative 'lib/database_connection'
require_relative 'lib/artist_repository'
require_relative 'lib/albums_repository'

class Application
  def initialize(database_name, io, album_repository, artist_repository)
    DatabaseConnection.connect('music_library')
    @io = io
    @album_repository = album_repository
    @artist_repository = artist_repository
    @choice = []
  end

  def run
    @io.puts "Welcome to the music library manager!"
    @io.puts "What would you like to do?"
    @io.puts "1 - List all albums"
    @io.puts "2 - List all artists"
    @io.puts "Enter your choice:"
    @choice = @io.gets.chomp
    @io.puts "Here is the list of albums:"
    self.output
  end
  
  def output
   if @choice == "1"
        album_repository = AlbumRepository.new
        album_repository.all.each do |record|
            @io.puts " * #{record.id} - #{record.title}"
        end
    elsif @choice == "2"
        artist_repository = ArtistRepository.new
        artist_repository.all.each do |record|
            @io.puts "* #{record.id} - #{record.name}"
        end
    end
  end
end

if __FILE__ == $0
  app = Application.new(
    'music_library',
    Kernel,
    AlbumRepository.new,
    ArtistRepository.new
  )
  app.run
end