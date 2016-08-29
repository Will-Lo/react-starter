class StudentsController < ApplicationController
  include ApplicationHelper

  # returns all students that are currently not deleted
	def get
		student = Student.where(is_deleted: false).index_by(&:id)
		if !student.empty?
			return response_data('Found all students.', student, 200)
		else
			return response_data('There are no students.', nil, 400)
		end
	end

	# creates a new student, along a student role
	def create
		student = Student.new(create_params)
		if student.save
			return response_data('Created new student.', student, 200)
		else
			return response_data('Could not create student.', student.errors.messages, 400)
		end
	end

	# edits selected student based on ID
	def edit
		if Student.exists?(edit_params[:id])
			student = Student.find(edit_params[:id])
			if student.update(edit_params)
	      return response_data('Editted student.', student, 200)
			else # failed to edit the student (wrong parameters passed)
	    	return response_data('Failed to edit student.', student.errors.messages, 400)
			end
		else # ID does not exist, therefore student does not exist
			return response_data('Student does not exist.', nil, 400)
		end
	end

  # removes a student from the database by updating the is_deleted column to true
  # this function will also remove all student roles related to this student
	def remove
		if Student.exists?(remove_params[:id])
			student = Student.find(remove_params[:id])
			if student.update_attribute(:is_deleted, 1)
				return response_data('Removed student.', student, 200)
			else # failed to remove the student
				return response_data('Failed to remove student.', student.errors.messages, 400)
			end
		else # ID does not exist, therefore student does not exist
			return response_data('Student does not exist.', nil, 400)
		end
	end

  # method parameters
  def create_params
  	params.permit(:name, :settings, :layout, :role_id)
  end

	def edit_params
    params.permit(:id, :name, :settings, :layout, :role_id)
	end

	def remove_params
    params.permit(:id)
	end
end
