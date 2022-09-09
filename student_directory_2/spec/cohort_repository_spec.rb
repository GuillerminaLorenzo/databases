require 'student'
require 'cohort'
require 'cohort_repository'

describe CohortRepository do
    def reset_students_table
        seed_sql = File.read('spec/seeds_student_directory_2.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'student_directory_2' })
        connection.exec(seed_sql)
    end

    before(:each) do 
        reset_students_table
    end

    it 'finds a cohort with its students' do
        repo = CohortRepository.new
        cohort = repo.find_with_students('1')

        expect(cohort.cohort_name).to eq 'August 2022'
        expect(cohort.starting_date).to eq '2022-08-15'
        expect(cohort.students.length).to eq 2
    end
end
