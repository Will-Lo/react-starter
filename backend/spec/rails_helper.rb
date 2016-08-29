# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  FactoryGirl.define do
    factory :amazon do
      id 1
      key_id 'AKIAIUHLQMEZHWXFU5LQ'
      secret_key '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'
      bucket_name 'advance-assets'
      created_at Time.now
      expires_at Time.now
    end

    factory :asset do
      id 1
      s3_path '00ca7181-33d9-4128-9fa0-429d66b13a74/cat.jpg'
      title 'First s3_path'
      desc 'This is my first time'
      share_link 'URL'
      category 'MD'
      thumbnail '00ca7181-33d9-4128-9fa0-429d66b13a74/cat.jpg'
      is_deleted false
      bucket_id 1
      sort_order 1
    end

    factory :data_source do
      id 1
      name 'My data source'
      table_data '{ "row_options": "one", "col_options": "one", "spec_options": "one" }'
      data_source_name 'OLAP'
      catalog 'Sales'
      options '{ "row_options": "one", "col_options": "one", "spec_options": "one" }'
    end

    factory :menu_item do
      id 1
      menu_id 1
      path 'URL'
      name "My Menu Item"
    end

    factory :menu_role do
      id 1
      menu_id 1
      role_id 1
      is_deleted false
    end

    factory :menu do
      id 1
      name 'My menu' 
      page 'Page' 
      is_external false
      path 'Path'
      parent_id 0
      children []
      is_deleted false
    end
    
    factory :page_role do
      id 1
      page_id 1
      role_id 1
      is_deleted false
    end

    factory :page do
      id 1
      name 'My page'
      settings '{ "id": "1", "name": "editor"}'
      layout '{ "id": "1", "name": "editor"}'
      is_deleted false
    end
    
    factory :portlet_role do
      id 1
      portlet_id 1
      role_id 1
      is_deleted false
    end

    factory :portlet do
      portlet_id 'abcdefghijklmnopqrstuvwxyzabcdefghij'
      name 'My portlet'
      styles '{"id":"2","name":"not-editor"}'
      json_data '{"id":"2","name":"not-editor"}'
      type_name  "type"
      titles "title"
      is_deleted false
    end

    factory :role do
      id 1
      name 'Admin'
      can_create_menus true
      can_create_pages true
      can_create_portlets true
      can_create_roles true
      can_create_users true
      is_deleted false
    end

    factory :user_role do
      id 1
      user_id 1
      role_id 1
      is_deleted false
    end

    factory :user do
      name 'test user'
      email 'test@test.com'
      password 'testing123'
      is_deleted false
    end
  end

  def config_setup
    if !User.exists?(1)
      create(:user)
    end
    if !Role.exists?(1)
      create(:role)
    end
    if !UserRole.exists?(1)
      create(:user_role)
    end
  end
  
  config.before(:all) do
    config_setup
    user_session_params = { :email => 'test@test.com', :password => 'testing123' }
    post '/sessions', user_session_params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(201)
    @token = (JSON.parse(response.body)['data'])
  end
  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
