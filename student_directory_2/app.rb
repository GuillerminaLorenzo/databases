require_relative 'lib/database_connection'
require_relative 'lib/cohort_repository'
require_relative 'lib/cohort'
require_relative 'lib/student'

class Application
  def initialize(database_name, io, cohort_repository)
    DatabaseConnection.connect('student_directory_2')
    @io = io
    @cohort_repository = cohort_repository
  end

  def run
    @io.puts "Welcome to the student directory manager!"
    @io.puts "Which cohort would you like to print?"
    cohort_id = @io.gets.chomp
    cohort =  @cohort_repository.find_with_students(cohort_id)
    @io.puts "#{cohort.cohort_name} cohort, starting date #{cohort.starting_date}"
    @io.puts "Here's the list:"
    num = 1
      cohort.students.each do |student|
        puts "#{num}. #{student.name}"
        num +=1
      end
  end
end

if __FILE__ == $0
  app = Application.new(
    'student_directory_2',
    Kernel,
    CohortRepository.new
  )
  app.run
end