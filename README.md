# Micro_learning_app
[![Build Status](https://travis-ci.org/caveinn/Micro_learning_app.svg?branch=develop)](https://travis-ci.org/caveinn/Micro_learning_app)


This is a simple application that allows users to create 
tutorials and others to get notifications depending on the type of tutorials they are
interested in

### Gems used
- sinatra. This is the microframewokr allowing the web pages to be served
- pg which allows for connection to the database
- bcrypt which allows for the hashing of passwords
- sinatra-activerecord which allows me to interuct with the db using
the activerecord orm
- rake which allows me to run migrations


### sinatra configuration 
This app is set up to run locally on port 4567 which is the default sinatra port
it also uses sessions for authentication
It is also configured to run with rack using the command `bundle exec rackup`

### setting the app up locally 
- clone the repo
- ensure you have a postgres database named micro_learning2
- run `bundle install`
- run migrations using the command `bundle exec rake db:migrate`
- run `ruby app.rb`

