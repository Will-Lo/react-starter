class PagesController < ApplicationController
  before_action :authenticate_user_from_token!
  include ApplicationHelper

  # returns all pages that are currently not deleted
	def get
  	check_permissions
		if @authorized == true
  		page = Page.where(is_deleted: false).index_by(&:name)
			if !page.empty?
				return response_data('Found all pages.', page, 200)
			else
				return response_data('There are no pages.', nil, 400)
			end
		else
			return response_data('You are not authorized to view pages.', @response, 400)
		end
	end

	# creates a new page, along a page role
	def create
		check_permissions
		if @authorized == true
			page = Page.new(create_params)
			if page.save
				PageRole.create(role_id: @user[0][:id], page_id: page[:id])
				return response_data('Created new page.', page, 200)
			else
				return response_data('Could not create page.', page.errors.messages, 400)
			end
		else
			return response_data('You are not authorized to create pages.', @response, 400)
		end
	end

	# edits selected page based on ID
	def edit
		authorize_role
		if @authorized == true
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
		else
			return response_data('Could not edit page.', @response, 400)
		end
	end

  # removes a page from the database by updating the is_deleted column to true
  # this function will also remove all page roles related to this page
	def remove
		authorize_role
		if @authorized == true
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
		else
			return response_data('Could not remove page.', @response, 400)
		end
	end

  # edits the is_deleted column on a portlet (removes it)
  # the reason this function is here rather than in the portlets_controller is because
  # row and cols are not user-specific, they belong solely to a page
  # therefore, the user should be authenticated to see if they can edit a page
	def remove_multiple_portlets
		delete = params[:remove]
		valid_response = []
		errors = []
		if !delete.blank?
			delete.each do |id|
				if !Portlet.where(portlet_id: id).blank?
					portlet = Portlet.where(portlet_id: id)[0]
					portlet.update_attribute(:is_deleted, 1)
					valid_response.push(portlet)
				else # ID does not exist, therefore portlet does not exist
					errors.push("Portlet with id #{id} does not exist.")
				end
			end
			return response_data('Removed portlets.', { "Successful remove(s)": valid_response, "Errors": errors }, 200)
		else
			return response_data('No params given.', nil, 400)
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
