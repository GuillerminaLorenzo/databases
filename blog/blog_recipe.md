# Student repository 2 Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table  comments`*

```
# EXAMPLE
Table: comments
| Record                | Properties          |
| --------------------- | ------------------  |
| post                  | title, content
| comment               | author, comment_content
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql

-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 
-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE posts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO posts (title, content) VALUES ('AAA', 'aaa');
INSERT INTO posts (title, content) VALUES ('BBB', 'bbb');

TRUNCATE TABLE comments RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO comments (author, comment_content, post_id) VALUES ('Guillermina', 'Good', '1');
INSERT INTO comments (author, comment_content, post_id) VALUES ('Christopher', 'Bad', '2');
INSERT INTO comments (author, comment_content, post_id) VALUES ('Emma', 'Very good', '1');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 blog_database < seeds_blog.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# Table name: posts
# Model class
# (in lib/cohort.rb)
class Post
end
# Repository class
# (in lib/cohort_repository.rb)
class PostRepository
end
# Table name: comments
# Model class
# (in lib/student.rb)
class Comment
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table name: posts
# Model class
# (in lib/post.rb)
class Post
  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :content, :comment
end
# Table name: comment
# Model class
# (in lib/comment.rb)
class Comment
  # Replace the attributes by your own columns.
  attr_accessor :id, :author, :comment_content, :post_id
end
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# Table name: posts
# Repository class
# (in lib/post_repository.rb)
class PostRepository
  # Gets a single post record with all its comments by its ID
  # One argument: the id (number)
  def find_with_comment(post_id)
    # Executes the SQL query:
    # SELECT posts.id, posts.title, comments.comment_content, comments.author
        # FROM posts
        # JOIN comments
        # ON posts.id = comments.post_id
        # WHERE posts.id = $1;
    # Returns an single cohort object with its associated comments
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES
# 1
# Get a cohort with its associated comments
repo = PostRepository.new
post = repo.find_with_comment('1')
post.id # => '1'
post.title #=> 'AAA'
post.comment.length # =>  2
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby 
# EXAMPLE
# file: spec/post_repository_spec.rb
def reset_blog_table
  seed_sql = File.read('spec/seeds_blog.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'blog_database' })
  connection.exec(seed_sql)
end
describe PostRepository do
  before(:each) do 
    reset_blog_table
  end
  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._