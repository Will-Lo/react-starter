require 'rails_helper'

RSpec.describe 'Page Request Tests', type: :request do

# rspec spec/requests/page_request_spec.rb - use in terminal in order to test the asset controller

	it 'should create a page' do
		page_params = { :name => 'My page', :settings => '{ "id": "1", "name": "editor"}', :layout => '{ "id": "1", "name": "editor"}' }
		post '/create_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(200)
		expect(JSON.parse(response.body)['data']['name']).to eq(page_params[:name])
		expect(JSON.parse(response.body)['data']['settings']).to eq(JSON.parse(page_params[:settings]))
		expect(JSON.parse(response.body)['data']['layout']).to eq(JSON.parse(page_params[:layout]))
		expect(JSON.parse(response.body)['data']['is_deleted']).to eq(false)
	end

	it 'should not create a page when the name is too long' do
		page_params = { :name => 'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvw', :settings => '{ "id": "1", "name": "editor"}', :layout => '{ "id": "1", "name": "editor"}' }
		post '/create_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data'].to_json).to eq('{"name":["is too long (maximum is 100 characters)"]}')
	end

	it 'should not create a page when the name is empty' do
		page_params = { :name => '', :settings => '{ "id": "1", "name": "editor"}', :layout => '{ "id": "1", "name": "editor"}' }
		post '/create_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data'].to_json).to eq('{"name":["is too short (minimum is 1 character)"]}')
	end

	it 'should not create a page when settings is empty' do
		page_params = { :name => 'My page', :settings => '', :layout => '{ "id": "1", "name": "editor"}' }
		post '/create_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data'].to_json).to eq('{"settings":["is too short (minimum is 1 character)"]}')
	end

	it 'should not create a page when the layout is empty' do
		page_params = { :name => 'My page', :settings => '{ "id": "1", "name": "editor"}', :layout => '' }
		post '/create_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data'].to_json).to eq('{"layout":["is too short (minimum is 1 character)"]}')
	end

	it 'should not create a page when no params are given' do
		page_params = { }
		post '/create_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['message'].to_json).to eq('"Could not create page."')
	end

	it 'should not create a page with invalid params or params that do not exist - ignore them' do
		page_params = { :name => 'My page', :settings => '{ "id": "1", "name": "editor"}', :layout => '{ "id": "1", "name": "editor"}', :is_deleted => true, :not_a_param => true }
		post '/create_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(200)
		expect(JSON.parse(response.body)['data']).not_to include('not_a_param')
	end

	it 'should edit a page based on id' do
		create(:page)
		create(:page_role)
		page_params = { :id => 1, :name => 'My page ... edited', :settings => '{ "id": "2", "name": "non-editor"}', :layout => '{ "id": "2", "name": "non-editor"}', :is_deleted => false }
		post '/edit_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(200)
		expect(JSON.parse(response.body)['data']['name']).to eq(page_params[:name])
		expect(JSON.parse(response.body)['data']['settings']).to eq(JSON.parse(page_params[:settings]))
		expect(JSON.parse(response.body)['data']['layout']).to eq(JSON.parse(page_params[:layout]))
		expect(JSON.parse(response.body)['data']['is_deleted']).to eq(false)
	end

	it 'should not edit a page when no id is given' do
  	create(:page)
		create(:page_role)
		page_params = { :id => '', :name => 'My page ... edited', :settings => '{ "id": "2", "name": "non-editor"}', :layout => '{ "id": "2", "name": "non-editor"}', :is_deleted => false }
		post '/edit_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token}
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data']).to eq('Page does not exist.')
	end

	it 'should not edit a page when id given does not exist' do
  	create(:page)
		create(:page_role)
		page_params = { :id => -1 }
		post '/edit_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data']).to eq('Page does not exist.')
	end	

	it 'should not edit a page when the name is too long' do
  	create(:page)
		create(:page_role)
		page_params = { :id => 1, :name => 'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvw', :is_deleted => 0 }
		post '/edit_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data'].to_json).to eq('{"name":["is too long (maximum is 100 characters)"]}')
	end

	it 'should not edit a page when the name is empty' do
  	create(:page)
		create(:page_role)
		page_params = { :id => 1, :name => '', is_deleted: 0 }
		post '/edit_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data'].to_json).to eq('{"name":["is too short (minimum is 1 character)"]}')
	end

	it 'should not edit a page when settings is empty' do
		create(:page)
		create(:page_role)
		page_params = { :id => 1, :name => 'My page', :settings => '', :layout => '{ "id": "1", "name": "editor"}' }
		post '/edit_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data'].to_json).to eq('{"settings":["is too short (minimum is 1 character)"]}')
	end

	it 'should not create a page when the layout is empty' do
		create(:page)
		create(:page_role)
		page_params = { :id => 1, :name => 'My page', :settings => '{ "id": "1", "name": "editor"}', :layout => '' }
		post '/edit_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data'].to_json).to eq('{"layout":["is too short (minimum is 1 character)"]}')
	end

	it 'should not edit a page when no params are given' do
  	create(:page)
		create(:page_role)
		page_params = { }
		post '/edit_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data']).to eq('Page does not exist.')
	end

	it 'should not edit a page with invalid params or params that do not exist - ignore them' do
  	create(:page)
		create(:page_role)
		page_params = { :id => 1, :name => 'My page', :is_deleted => true, :not_a_param => true }
		post '/edit_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(200)
		expect(JSON.parse(response.body)['data']).not_to include('not_a_param')
	end

	it 'should remove a page based on id' do
  	create(:page)
  	create(:page_role)
		page_params = { :id => 1 }
		delete '/remove_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(200)
		expect(JSON.parse(response.body)['data']['id']).to eq(page_params[:id])
		expect(JSON.parse(response.body)['data']['is_deleted']).to eq(true)
	end

	it 'should not remove a page when no id is given' do
  	create(:page)
		create(:page_role)
		page_params = { :id => '' }
		delete '/remove_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data']).to eq('Page does not exist.')
	end

	it 'should not remove a page when id does not exist' do
  	create(:page)
		create(:page_role)
		page_params = { :id => -1 }
		delete '/remove_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data']).to eq('Page does not exist.')
	end	

	it 'should not remove a page when no params are given' do
  	create(:page)
		create(:page_role)
		page_params = { }
		delete '/remove_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['data']).to eq('Page does not exist.')
	end

	it 'should not remove a page with invalid params or params that do not exist - ignore them' do
  	create(:page)
		create(:page_role)
		page_params = { :id => 1, :is_deleted => true, :not_a_param => true }
		delete '/remove_page', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(200)
		expect(JSON.parse(response.body)['data']).not_to include('not_a_param')
	end

	it 'should remove multiple portlets on a page based on ids' do
  	create(:page)
  	create(:page_role)
  	create(:portlet, portlet_id: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', id: 1)
  	create(:portlet, portlet_id: 'ffffffffffffffffffffffffffffffffffff', id: 2)
		page_params = { :id => 1, :remove => ['aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'ffffffffffffffffffffffffffffffffffff'] }
		delete '/remove_multiple_portlets', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(200)
		expect(JSON.parse(response.body)['data'].length).to eq(2)
		expect(JSON.parse(response.body)['data']['Successful remove(s)'][0]['is_deleted']).to eq(true)
		expect(JSON.parse(response.body)['data']['Successful remove(s)'][1]['is_deleted']).to eq(true)
	end

	it 'should not remove multiple portlets when no ids are given' do
  	create(:page)
  	create(:page_role)
  	create(:portlet, portlet_id: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', id: 1)
  	create(:portlet, portlet_id: 'ffffffffffffffffffffffffffffffffffff', id: 2)
		page_params = { :id => 1, :remove => ['', ''] }
		delete '/remove_multiple_portlets', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(200)
		expect(JSON.parse(response.body)['data']['Errors'][0]).to eq('Portlet with id  does not exist.')
		expect(JSON.parse(response.body)['data']['Errors'][1]).to eq('Portlet with id  does not exist.')
	end

	it 'should not remove multiple portlets when no params are given' do
  	create(:page)
  	create(:page_role)
  	create(:portlet, portlet_id: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', id: 1)
  	create(:portlet, portlet_id: 'ffffffffffffffffffffffffffffffffffff', id: 2)
		page_params = { }
		delete '/remove_multiple_portlets', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(400)
		expect(JSON.parse(response.body)['message']).to eq('No params given.')
	end

	it 'should not remove multiple portlets when the ids do not exist' do
  	create(:page)
  	create(:page_role)
  	create(:portlet, portlet_id: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', id: 1)
  	create(:portlet, portlet_id: 'ffffffffffffffffffffffffffffffffffff', id: 2)
		page_params = { :id => 1, :remove => [-1, -1] }
		delete '/remove_multiple_portlets', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(200)
		expect(JSON.parse(response.body)['data']['Errors'][0]).to eq('Portlet with id -1 does not exist.')
		expect(JSON.parse(response.body)['data']['Errors'][1]).to eq('Portlet with id -1 does not exist.')
	end

	it 'should remove multiple portlets without invalid params or params that do not exist - ignore them' do
  	create(:page)
  	create(:page_role)
  	create(:portlet, portlet_id: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', id: 1)
  	create(:portlet, portlet_id: 'ffffffffffffffffffffffffffffffffffff', id: 2)
		page_params = { :id => 1, :remove => ['aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'ffffffffffffffffffffffffffffffffffff'], :not_a_param => true }
		delete '/remove_multiple_portlets', page_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'AUTHORIZATION' => @token }
		expect(response.status).to eq(200)
		expect(JSON.parse(response.body)['data']['Successful remove(s)'][0]).not_to include('not_a_param')
		expect(JSON.parse(response.body)['data']['Successful remove(s)'][1]).not_to include('not_a_param')
	end

end
