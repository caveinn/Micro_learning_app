# Micro_learning_app
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

### setting the app up locally 
- clone the repo
- run the postgre dump provided `This is a work in progress`
- run `bundle install`
- run `ruby app.rb`

### pending
- Finish styling the app and debug
- allow for editing og tutorials
- polish the traversal of links to improve ux
