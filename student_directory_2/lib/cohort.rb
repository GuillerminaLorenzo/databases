class Cohort
    attr_accessor :id, :cohort_name, :starting_date, :students
    
    def initialize
        @students = []
    end
end