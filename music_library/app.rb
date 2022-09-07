# file: app.rb

require_relative 'lib/database_connection'
require_relative 'lib/artist_repository'
require_relative 'lib/albums_repository'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('music_library')

# Perform a SQL query on the database and get the result set.
# sql = 'SELECT id, title FROM albums;'
# result = DatabaseConnection.exec_params(sql, [])

artist_repository = ArtistRepository.new

artist_repository.all.each do |record|
  puts "#{record.id} - #{record.name} - #{record.genre}"
end

# artist_repository.all.each do |record|
#   p record
# end

album_repository = AlbumRepository.new

album_repository.all.each do |record|
  puts "#{record.id} - #{record.title} - #{record.release_year} - #{record.artist_id}"
end

# album_repository.all.each do |record|
#   p record
# end

# Get the album with id 3
album = album_repository.find(3)

puts album.id
puts album.title
puts album.release_year

artist = artist_repository.find(2)

puts artist.id
puts artist.name
puts artist.genre