class StudentsController < ApplicationController
  include ApplicationHelper

  # returns all pages that are currently not deleted
	def get
		page = Page.where(is_deleted: false).index_by(&:name)
		if !page.empty?
			return response_data('Found all pages.', page, 200)
		else
			return response_data('There are no pages.', nil, 400)
		end
	end

	# creates a new page, along a page role
	def create
		page = Page.new(create_params)
		if page.save
			PageRole.create(role_id: @user[0][:id], page_id: page[:id])
			return response_data('Created new page.', page, 200)
		else
			return response_data('Could not create page.', page.errors.messages, 400)
		end
	end

	# edits selected page based on ID
	def edit
		if Page.exists?(edit_params[:id])
			page = Page.find(edit_params[:id])
			if page.update(edit_params)
	      return response_data('Editted page.', page, 200)
			else # failed to edit the page (wrong parameters passed)
	    	return response_data('Failed to edit page.', page.errors.messages, 400)
			end
		else # ID does not exist, therefore page does not exist
			return response_data('Page does not exist.', nil, 400)
		end
	end

  # removes a page from the database by updating the is_deleted column to true
  # this function will also remove all page roles related to this page
	def remove
		if Page.exists?(remove_params[:id])
			page = Page.find(remove_params[:id])
			if page.update_attribute(:is_deleted, 1)
      	page_role = PageRole.where(id: page[:id])
      	page_role.each do |role|
      		role.update_attribute(:is_deleted, 1)
      	end
				return response_data('Removed page.', page, 200)
			else # failed to remove the page
				return response_data('Failed to remove page.', page.errors.messages, 400)
			end
		else # ID does not exist, therefore page does not exist
			return response_data('Page does not exist.', nil, 400)
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
