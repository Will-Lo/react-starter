# AdvanceX Backend End Documentation

It is recommended that you be familiar with the [Rails naming conventions](https://gist.github.com/iangreenleaf/b206d09c587e8fc6399e) as they will make your development experience much smoother.

## Ruby on Rails Install Guide

Please ensure you have the following installed before you continue. You can find great documentation online on how to install these dependencies.

1. [Homebrew - Mac](http://brew.sh/)  
 - The command you'll want to use is `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
2. [RVM (Ruby Version Manager) v1.26.11](https://rvm.io/rvm/install)  
 - The command you'll want to use is `\curl -sSL https://get.rvm.io | bash -s stable --rails`    
*After RVM has installed, make sure to restart terminal. This will allow you to access RVM.*
3. [Rails v4.2.6](http://installrails.com/steps/choose_os)
 - Since AdvanceX is not using the most current version of [Ruby](https://www.ruby-lang.org/en/documentation/installation/), you'll want to run `rvm use 2.3.0`
4. Postgres
 - Through Homebrew in your terminal, run `brew install postgresql`
5. Project Setup
 - Once in the backend folder, run `gem install bundler`. This will allow you to install the package that will be running the Rails server.
 - Next, execute `bundle install` and let all the packages finish installing. This includes all the gems powering the backend, and all the dependencies needed for those gems.	
 - You'll need to start your postgres database to access the information for the app, so run this command `pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`
 - Then you'll need to run `rake db:reset` to get all the default data stored into the database
 - Use `rails s` to start the server, and you'll be off to the races.

##Development

Developing with Rails for our project will not consist of the full MVC architecture, but simply the model and controller aspect of the interface. Many people are choosing Rails as their go-to backend platform simply because of the "magic" behind the language. Writing server queries can be done in a matter of seconds, and using models alongside your controllers further simplifies the process of accessing data from a server. 

For this specific project, we have chosen PostgreSQL as of database. Although there are many different database architectures to choose from, Postgres was an easy choice for us given its flexibility in different production scenarios and support for multiple SQL constructs.

Check out [this](https://betterexplained.com/articles/intermediate-rails-understanding-models-views-and-controllers/) link for an in depth overview of the different parts of the Rails architecture. Keep in mind that the "view" portion of this article is handled by our frontend which runs React, Rails will not be handling the view the users sees.

### Developer Tools - Your New Bestfriend
Following these steps are not required, but are definitely useful for visual aid and testing throughout your development experience with Rails and PostgreSQL.

1. [Advanced REST Client](https://chrome.google.com/webstore/detail/advanced-rest-client/hgmloofddffdnphfgcellkdfbfbjeloo) - You will be using this tool probably the most out of all the others. It allows you to make calls to the API end points, and shows you the return data that the server presents to you upon completion. [Here](ARC.md) you can find some useful information on how to use the client.
2. [Postman](https://www.getpostman.com/) - API request software. This will allow you to easily build API calls to HTTP endpoints in your Rails app in order to test the JSON objects your send and receive to/from the server. This is a useful tools as it allows you to build objects in order to serve up information in many different ways, find errors in your code, and watch as you succeed while building models and controllers.
3. [DbVisualizer](https://www.dbvis.com/) - The name says it all. This programs allows you to connect to either a local, or live server and access the according database. This will be able to show you table and entries, relations, and query each database via the SQL command line.
4. [JSONWebToken](https://stormpath.com/blog/token-auth-spa) - JWT's are the way we are handling authentication in our app. A JWT is made up of 3 parts: the header, payload (data), and signature. The signature is a hash of all 3 sections, thus if anyone modifies the token (which is base 64 encoded), the signature will become invalid and the token disregarded. Since we are using a REST API, it is common to use a token as opposed to a cookie in order to validate sessions, user permission, etc. This is because Advnace has been developped as a single page app, meaning there is no routing through the URL's in order to access different pages on the site. Token are a clean and efficient way to carry user and session information to our different API end points in order to validate HTTP requests.
5. [AdvanceX Server API Calls](http://advance.innovasium.com/docs/) - This website contains an updated list of all the current API calls that can be found for the AdvanceX site. The Frontend will make good use of this list, as these are the endpoints they will need to access in order to send any data to the server. Keeping this list updated is crucial.

### Running RSpec tests on controllers

Installed with the gemfile of this app is a testing framework called RSpec. There is a great [repo](https://github.com/rspec/rspec-rails) on GitHub with documentation to help you contruct your own tests. We will be using this alongside [FactoryGirl](https://github.com/thoughtbot/factory_girl) (fixture replacement for test entries in database) in order to test each of our application controllers for any bugs or errors caught whilst using the app. The point of these tests is to simulate a user entering incorrect parameters, null fields, bad JSON data, etc. Make your way to the [spec/requests](spec/requests) folder to find our currently existing tests.

1. In terminal, enter the command `rails generate rspec:request *name of test file*`. This will add a new file to your request folder for you to write tests inside.  
2. To run a test on your local server, simply run the command `rspec spec/requests/*test file*` to execute your controller tests (If you want to run all tests in your spec folder, run `bundle exec spec`)  

## Technical Details

### User Authentication System
We are using a gem called Devise for our login and authentication system. That said, we're not completely following the Devise model as we are using token based authentication which has been removed from their library. This is because Devise has moved to server side rendering of forms for their validation methods and using tokens is a rather simpler and easy implementation.

1. When a user logs in for the first time, the rails server receives a request that goes to the sessions controller via `/sessions`. If the user provided the correct credentials a [Json Web Token](https://jwt.io/introduction/) is generated.
2. Once the user has passed the validation check and receives the token, the token is passed into `backend/app/controllers/user_controller` which logs the user in. The controller runs the JWT through Devise to validate that the token isn't invalide or expired, and then returns all pages, menus and portlets to the frontend to render a view. The token is the source of truth here, if anyone gets your token and your token hasn't expired (they expire in 24 hours by default) they can login to your account.
3. At this point, the token is stored into a cookie and appended to all API requests as a way to authenticate the user initiating the request.

### Updating API Documentation

These days, no is no reason to build your own site to display API endpoints when there are handy little tools such as [Slate](https://github.com/lord/slate).

Follow the `Getting Set Up` section in their repo documentation in order to get Slate working on your local machine.

Once you're set up and inside the Slate folder, you can find the `source/index.html.md` file. This is what you will use to edit all the documentation and add new endpoints as well.

> Use `bundle exec middleman server` to start the server included in the Slate bundle. You can then head over [here](http://localhost:4567/#asset) to find your documentation.  
If you're looking to add your documentation notes to the live server, you'll first need a fresh build of the changes you've made. Inside your terminal, run `bundle exec middleman build --clean` inside the Slate folder. Then take all the files from inside the `build` folder and place them in `AdvanceX/frontend/public/docs`.  

You'll have to ask Ryan or Matt to push your changes to the live server.

### Server Controls (Amazon)

1. To start up the rails server, run `rails s`.
2. To bind the server to a specific port X, add `-p X` to the command in step 1.
3. To bind the server to a specific ip Y, add `-b Y` to the command in step 1.
4. To run the server as a background service (daemon), add the `-d` option to the command in step 1
(final command should be: `rails s -b 0.0.0.0 -p 3000 -d`
5. To stop a server that is not running as a background service, in terminal press Ctrl + c.
6. To stop a server that is running as a background service, input `kill -9 $(cat tmp/pids/server.pid)`.
7. To restart the rails server running on AWS, you will need a secret access key to ssh into the server and restart it manually - talk to Dan or Rob to retrieve it if needed. The host name is: ubuntu@ec2-52-207-229-104.compute-1.amazonaws.com. Run the following command to ssh into the AWS instance: `ssh -i "Saruman-Key.pem" ubuntu@ec2-52-207-229-104.compute-1.amazonaws.com`. The backend folder is located in \home\ubuntu\AdvanceX\backend. See Ryan for any additional server restart help.

##Other Documentation

[Main Documentation](../README.md)

[Front End Documentation](../frontend/README.md)

[DnD and Portlet Documentation](./AppDetails.md)

[Dependencies List](../dependencies.md)

[Server API Calls](http://advance.innovasium.com/docs/)

[FAQ](../FAQ.md)
