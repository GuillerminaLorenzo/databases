require_relative 'cohort'
require_relative 'student'


class CohortRepository
    def find_with_students(cohort_id)
      sql = 'SELECT cohorts.id AS "id", 
                cohorts.starting_date AS "starting_date",
                cohorts.cohort_name AS "cohort_name",
                students.name AS "name"
            FROM cohorts
                JOIN students
                ON cohorts.id = students.cohort_id
            WHERE cohorts.id = $1;'

      params = [cohort_id]
      result = DatabaseConnection.exec_params(sql, params)
      first_record = result[0]
      cohort = record_to_cohort_object(first_record)

      result.each do |record|
        cohort.students << record_to_student_object(record)
      end
      cohort
    end

    private

    def record_to_cohort_object(record)
      cohort = Cohort.new
      cohort.id = record['id']
      cohort.cohort_name = record['cohort_name']
      cohort.starting_date = record['starting_date']

      return cohort
    end

    def record_to_student_object(record)
      student = Student.new
      student.name = record['name']
      
      return student
    end
  end