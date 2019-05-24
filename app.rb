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
    unless session.has_key?("user_name")  
        @error = "kindly log in"
        redirect "/login"
    end
    @user = User.find_by(user_name: session["user_name"] )
    erb :profile
end 

get "/update_profile" do 
    unless session.has_key?("user_name")  
        redirect "/login"
    end
    @user = User.find_by(user_name: session["user_name"])
    erb :update_profile
end

get "/tutorial" do
    unless session.has_key?("user_name")  
        redirect "/login"
    end
    erb :tutorialForm
end

post "/tutorial" do
    unless session.has_key?("user_name") 
        @error = "please login"
        
        redirect "/login"
    end
    user  = User.find_by(user_name: session["user_name"] )
    tutorial = user.tutorials.create(title: params["title"], topic: params["topic"], content: params["content"])
    redirect "/tutorial/"+tutorial.id.to_s
end

get "/tutorial/:id" do
    @tutorial = Tutorial.find_by(id: params[:id])
    puts ENV["RACK_ENV"]
    erb :tutorial
end

post '/update_profile' do
    puts params.inspect
    user = User.find_by(user_name: session["user_name"])
    user.user_name = params["user_name"]
    user.interests = params["interests"]
    user.role = params["role"] 
    user.save
    redirect "/profile"
end

get "/pages" do
    @tutorials = Tutorial.all
    erb :pages
end
