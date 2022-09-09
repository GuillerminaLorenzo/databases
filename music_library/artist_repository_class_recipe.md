{{Artists}} Model and Repository Classes Design Recipe
Copy this recipe template to design and implement Model and Repository classes for a database table.

1. Design and create the Table
If the table is already created in the database, you can skip this step.

Otherwise, follow this recipe to design and create the SQL schema for your table.

In this template, we'll use an example table students

2. Create Test SQL seeds
Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.
 
 ```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE artists RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO artists (name, genre) VALUES ('Pixies', 'Rock');
INSERT INTO artists (name, genre) VALUES ('ABBA', 'Pop');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name_test < seeds_{table_name}.sql
```
3. Define the class names
Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by Repository for the Repository class name.

```ruby
# EXAMPLE
# Table name: artists

# Model class
# (in lib/artists.rb)
class Artist
end

# Repository class
# (in lib/artist_repository.rb)
class ArtistRepository
end
```

4. Implement the Model class
Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby

class Artist
    attr_accessor :id, :name, :genre 
end
```

You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.

5. Define the Repository Class interface
Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: artists

# Repository class
# (in lib/artists_repository.rb)

class ArtistRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, genre FROM artists;

    # Returns an array of Artists objects.
  end
  def find(id)
    # Executes the SQL
    # SELECT id, name, genre FROM artists WHERE id = $1;

    # Retuens a sinlge Artists object
  end
  def create(artist)
    # sql = 'INSERT INTO artists (name, genre) VALUES ($1, $2);'

    # doesn't need to return anything(only creates the record)
  end
  def delete(id)
    # sql = 'DELETE FROM artists WHERE id = $1;'

    # doesn't need to return anything(only deletes the record)
  end
  def update(artist)
    # sql = 'UPDATE artists SET name = $1, genre = $2 WHERE id = $3;'

    # doesn't need to return anything(only updates the record)
  end
  def find_with_albums(id)
  # 'SELECT artists.id AS "id",
  #    artists.name AS "name,
  #    artists.genre AS "genre,
  #    albums.id AS "album_id",
  #    albums.title AS "title",
  #    albums.release_year AS "release_year"
  #  FROM artists
  #  JOIN albums 
  #  ON albums.artist_id = artists.id
  #  WHERE artists.id = $1;'

  # Returns an Artists object
  # with the array of Album objects
  end
end
```

6. Write Test Examples
Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all artists

repo = ArtistRepository.new

artists = repo.all

artists.length # =>  2

artists[0].id # =>  1
artists[0].name # =>  'Pixies'
artists[0].genre # =>  'Rock'

# 2
# Get a single artist ('Pixies')

repo = ArtistRepository.new
artist = repo.find(1)

artist.name # => 'Pixies'
artist.genre # => 'Rock'

# 3
# Get a single artist ('ABBA')

repo = ArtistRepository.new
artist = repo.find(2)

artist.name # => 'ABBA'
artist.genre # => 'Pop'

# Create a new artist
repo = ArtistRepository.new

artist = Artist.new
artist.name = 'Bad Bunny'
artist.genre = 'Reggaeton'

repo.create(artist) # => nil

artists = repo.all

last_artist = artists.last
last_artist.name # => 'Bad Bunny'
last_artist.genre # => 'Reggeaton'

# Delete an artist
repo = ArtistRepository.new

artist = repo.find(1)

repo.delete(artist.id)

artists = repo.all
artists.length # => 1
artists[0].id # => '2'

# Update an artist
repo = ArtistRepository.new

artist = repo.find(1)

artist.name = 'aaaa'
artist.genre = 'bbbb'

repo.update(artist)

artists = repo.find(1)

artists.name # => 'aaaa'
artists.genre # => 'bbbb'

# 
repo = ArtistRepository.new

artist = repo.find_with_albums(1)

artist.name # => 'Pixies'
artist.genre # => 'Rock'
artist.albums.length # => 2
artist.albums.first.title # => 'Bossanova'


# Add more examples for each method
```

Encode this example as a test.

7. Reload the SQL seeds before each test run
Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

describe ArtistRepository do
    def reset_students_table
        seed_sql = File.read('spec/seeds_artists.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'muisc_library_test' })
        connection.exec(seed_sql)
    end
    
    before(:each) do 
        reset_artists_table
    end
end
```