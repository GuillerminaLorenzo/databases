TRUNCATE TABLE cohorts, students RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO cohorts (cohort_name, starting_date) VALUES ('August 2022', '2022, 08, 15');
INSERT INTO cohorts (cohort_name, starting_date) VALUES ('July 2022', '2022, 07, 15');

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO students (name, cohort_id) VALUES ('Guillermina', '1');
INSERT INTO students (name, cohort_id) VALUES ('Christopher', '2');
INSERT INTO students (name, cohort_id) VALUES ('Emma', '1');