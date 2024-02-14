# Introduction

This project is a Web API service built using Ruby on Rails. Its main function is to shorten a long URL and provide a short URL that would be used for sharing with others. The short URL should be translated back to the long one once used by public users.

# Application parts

The application has two controllers, one is secured to provide the shortened URL functionality, and the other one is public for decoding the short URL into the long one and sending it back to the user (browser).

The application depends on the PostgreSQL database to store the long URL with its related code. To hold this model a class is already created to have the long_url, short_code, and by default the created and updated date/time.

# Configuring the Application

## Routing

We need to define the different routes the service will handle, which can be done inside the "/config/routes.rb" file:

    Rails.application.routes.draw do
      get 'get_full_url/create'
      get 'shorten/create'
      # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
    
      # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
      # Can be used by load balancers and uptime monitors to verify that the app is live.
      get "up" => "rails/health#show", as: :rails_health_check
    
      # Defines the root path route ("/")
      # root "posts#index"
    
      post '/api/shorten', to: 'shorten#create'
      get '/:id', to: 'get_full_url#create'
    end

## Database connection

We need to install the PostgreSQL engine locally (or bring a Docker image and run it locally), or if there is access to an online PostgreSQL it would be possible as well.

The database connection should be defined inside the "/config/database.yaml" file:

    # SQLite. Versions 3.8.0 and up are supported.
    #   gem install sqlite3
    #
    #   Ensure the SQLite 3 gem is defined in your Gemfile
    #   gem "sqlite3"
    #
    default: &default1
      adapter: sqlite3
      pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
      timeout: 5000
    
    default: &default
      adapter: postgresql
      encoding: unicode
      database: ShortenURL
      username: postgres
      password: postgres
      host: localhost
      port: 5432
    
    development:
      <<: *default
      
    # Warning: The database defined as "test" will be erased and
    # re-generated from your development database when you run "rake".
    # Do not set this db to the same as development or production.
    test:
      <<: *default

    # The following env variables would be defined later during deployments
    production:
      <<: *default
      database: <%= ENV['POSTGRES_DB'] %>
      username: <%= ENV['POSTGRES_USER'] %>
      password: <%= ENV['POSTGRES_PASSWORD'] %>
      host: db

# Running the service

## Create the database

Now we are ready to create the database and migrate the model, this can be done using the following code:

    rails generate model ShortUrl long_url:string short_code:string
    rails db:migrate

## Run the Rails server

We are ready now to launch the service:

    rails s

If no errors appear, you can use another terminal (or postman) to test the service using curl:

    curl -X POST \
    http://localhost:3000/api/shorten\
    -H 'Content-Type: application/json' \
    -u user:password \
    -d '{
       "long_url": "http://ruby-doc.com/docs/ProgrammingRuby/"
    }'

This call has a basic hardcoded authentcation with username: user , and password: password

The call should return the short URL, which will display the long URL once used in the browser.

Another check can be done on the database table to see if the entry already logged.

# Enhancement

* Create a scheduler to delete old entries based on a configurable duration, just to clean the database from old entries.
* Configure the secured controller to read user identity dynamicall from an identity provider
* I faced many challanges on deploying Ruby 3.3.0 with pg on docker, still working on this item till it gets done




