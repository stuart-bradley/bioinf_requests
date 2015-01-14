class Employee < ActiveRecord::Base
	validates :name, presence: true 
	belongs_to :request

	# Sorts employees by last name. 
	def self.sorted_employees_list
		employees_unsorted = Employee.all
		employees_sorted = employees_unsorted.sort_by do |emp|
			emp.name.split(" ").reverse.join.upcase
		end

		employees_sorted_array = []
		employees_sorted.each {|emp| employees_sorted_array << emp.name}

		return employees_sorted_array
	end
end
