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

album_repository = AlbumRepository.new

album_repository.all.each do |record|
  puts "#{record.id} - #{record.title} - #{record.release_year} - #{record.artist_id}"
end