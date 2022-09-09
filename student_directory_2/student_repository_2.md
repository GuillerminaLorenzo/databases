# Student repository 2 Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE
Table: students
| Record                | Properties          |
| --------------------- | ------------------  |
| cohort                | name, starting_date
| student               | name, cohort_id
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

TRUNCATE TABLE cohorts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO cohorts (name, starting_date) VALUES ('August 2022', '2022, 08, 15');
INSERT INTO cohorts (name, starting_date) VALUES ('July 2022', '2022, 07, 15');

TRUNCATE TABLE students RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO students (name, cohort_id) VALUES ('Guillermina', '1');
INSERT INTO students (name, cohort_id) VALUES ('Christopher', '2');
INSERT INTO students (name, cohort_id) VALUES ('Emma', '1');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 student_directory_2 < seeds_student_directory_2.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# Table name: cohorts
# Model class
# (in lib/cohort.rb)
class Cohort
end
# Repository class
# (in lib/cohort_repository.rb)
class CohortRepository
end
# Table name: students
# Model class
# (in lib/student.rb)
class Student
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table name: cohorts
# Model class
# (in lib/cohort.rb)
class Cohort
  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :starting_date
end
# Table name: students
# Model class
# (in lib/student.rb)
class Student
  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :cohort_id
end
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# Table name: cohorts
# Repository class
# (in lib/cohort_repository.rb)
class CohortRepository
  # Gets a single cohort record with all its students by its ID
  # One argument: the id (number)
  def find_with_student(id)
    # Executes the SQL query:
    # SELECT cohorts.id, cohorts.starting_date, students.name 
        # FROM cohorts
        # JOIN students
        # ON cohorts.id = students.cohort_id
        # WHERE cohorts.id = $1;
    # Returns an single cohort object with its associated students
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES
# 1
# Get a cohort with its associated students
repo = CohortRepository.new
cohort = repo.find_with_student('1')
cohort.name #=> 'August 2022'
cohort.starting_date #=> '2022, 08, 15'
cohort.students.length # =>  2
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby 
# EXAMPLE
# file: spec/student_repository_spec.rb
def reset_students_table
  seed_sql = File.read('spec/seeds_students.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'students' })
  connection.exec(seed_sql)
end
describe StudentRepository do
  before(:each) do 
    reset_students_table
  end
  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._