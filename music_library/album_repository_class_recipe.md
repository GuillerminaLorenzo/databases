{{Albums}} Model and Repository Classes Design Recipe
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

TRUNCATE TABLE artists RESTART IDENTITY

TRUNCATE TABLE albums RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO artists (name, genre) VALUES ('Pixies', 'Rock');

INSERT INTO albums (title, release_year, artist_id) VALUES ('Bossanova', '1999', '1');
INSERT INTO albums (title, release_year, artist_id) VALUES ('Surfer Rosa', '2001', '1');
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
class Album
end

# Repository class
# (in lib/artist_repository.rb)
class AlbumRepository
end
```

4. Implement the Model class
Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby

class Album
    attr_accessor :id, :title, :release_year, :artist_id
end
```

You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.

5. Define the Repository Class interface
Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: albums

# Repository class
# (in lib/albums_repository.rb)

class AlbumRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums;

    # Returns an array of Artists objects.
  end

  # Select a single album record
  # Given its id in argument (a number)
  def find(id)
    # Executes the SQL
    # SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;

    # Retuens a sinlge Album object
  end

end
```

6. Write Test Examples
Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all albums

repo = AlbumRepository.new
albums = repo.all

albums.length # =>  2

albums[0].title # =>  'Bossanova'
albums[0].release_year # =>  '1999'
albums[0].artist_id # => '1'

# 2
# Get all albums when there are no albums in the DB

repo = AlbumRepository.new
albums = repo.all # => []

# 3 
# Get a single album ('Bossanova')

repo = AlbumRepository.new
albums = repo.find(1)

album.title # => 'Bossanova'
album.release_year # => '1999'
album.artist_id # => '1'

# 4 
# Get a single album ('Surfer Rosa')

repo = AlbumRepository.new
albums = repo.find(2)

album.title # => 'Surfer Rosa'
album.release_year # => '2001'
album.artist_id # => '1'

```

Encode this example as a test.

7. Reload the SQL seeds before each test run
Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

describe AlbumRepository do
    def reset_albums_table
        seed_sql = File.read('spec/seeds_albums.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'muisc_library_test' })
        connection.exec(seed_sql)
    end
    
    before(:each) do 
        reset_albums_table
    end
end
```