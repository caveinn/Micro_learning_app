require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'


enable :sessions

class User < ActiveRecord::Base
    has_many :tutorials, dependent: :destroy
end

class Tutorial < ActiveRecord::Base
    belongs_to :user
end

get "/" do 
   erb :home    
end

get "/signup" do
    erb :signup
end

post "/signup" do
    # create a new user
    password = BCrypt::Password.create(params["password"])
    puts params.inspect
    user_name = params["user_name"].strip
    email = params["email"].strip
    role = "reader"
    user = User.create(user_name: user_name, password: password, role: role, email: email)
    redirect "/login"
end
 
get "/login" do
    erb :login
end

post "/login" do
    #authenticat a user
    user = User.find_by(user_name: params["user_name"].strip)
    user_pass = BCrypt::Password.new(user.password)
    if user_pass == params["password"] 
        session["user_name"] = user.user_name
        redirect "/profile"
    end
    @error = "Wrong password or username try again"
    erb :login
end

get "/profile" do 
    # display user info
    unless session.has_key?("user_name")  
        @error = "kindly log in"
        redirect "/login"
    end
    @user = User.find_by(user_name: session["user_name"] )
    erb :profile
end 

get "/update_profile" do 
    # update users info allowing them to become writers
    unless session.has_key?("user_name")  
        redirect "/login"
    end
    @user = User.find_by(user_name: session["user_name"])
    erb :update_profile
end

get "/tutorial" do
    # get a tutorial form to display to the user
    unless session.has_key?("user_name")  
        redirect "/login"
    end
    erb :tutorialForm
end

post "/tutorial" do
    # create a new tutorial entry
    unless session.has_key?("user_name") 
        redirect "/login"
    end
    user  = User.find_by(user_name: session["user_name"] )
    tutorial = user.tutorials.create(title: params["title"], topic: params["topic"], content: params["content"])
    redirect "/tutorial/"+tutorial.id.to_s
end

get "/tutorial/:id" do
    # get a single tutorial entry from the DB
    @tutorial = Tutorial.find_by(id: params[:id])
    puts ENV["RACK_ENV"]
    erb :tutorial
end

post '/update_profile' do
    # update users info in the database
    puts params.inspect
    user = User.find_by(user_name: session["user_name"])
    user.user_name = params["user_name"]
    user.interests = params["interests"]
    user.role = params["role"] 
    user.save
    redirect "/profile"
end

get "/pages" do
    # show all the available tutorials
    @tutorials = Tutorial.all
    erb :pages
end
