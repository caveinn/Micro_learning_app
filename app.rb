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
   "Welcome to the micro-learning app"    
end

get "/signup" do
    erb :signup
end

post "/signup" do
    password = BCrypt::Password.create(params["password"])
    puts params.inspect
    user_name = params["user_name"]
    email = params["email"]
    role = "reader"
    user = User.create(user_name: user_name, password: password, role: role, email: email)
    redirect "/login"
end

get "/login" do
    erb :login
end

post "/login" do
    puts params.inspect
    user = User.find_by(user_name: params["user_name"])
    user_pass = BCrypt::Password.new(user.password)
    if user_pass == params["password"] 
        session["user_name"] = user.user_name
        redirect "/profile"
    end
    @error = "Wrong password or username try again"
    erb :login
end

get "/profile" do 
    puts session.inspect
    @user = User.find_by(user_name: session["user_name"] )
    erb :profile
end 

get "/tutorial" do
    erb :tutorialForm
end

post "/tutorial" do
    puts params.inspect
    user  = User.find_by(user_name: session["user_name"] )
    tutorial = user.tutorials.create(title: params["title"], topic: params["topic"], content: params["content"])
    redirect "/tutorial/"+tutorial.id.to_s
end

get "/tutorial/:id" do
    @tutorial = Tutorial.find_by(id: params[:id])
    erb :tutorial
end
