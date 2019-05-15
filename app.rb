require 'sinatra'
require 'pg'
require 'bcrypt'

enable :sessions
$conn = PG.connect(dbname: "micro_learning")

def get_all_entries tablename
    # get all the entries in a given table
    entries = {tablename => [] }
    $conn.exec("SELECT * FROM #{tablename}").each{|entry| entries[tablename].push(entry)}
    entries
end


def add_entry tablename, value_hash
    values = ""
    columns = ""
    value_hash.each do |column, value|
         columns+= column + ", "
         values += "'" +value+"', "
    end
    $conn.exec("INSERT  INTO #{tablename} (#{columns.chomp(", ")}) VALUES  (#{values.chomp(", ")})  ")
end

def get_entry tablename, value_hash
    stmtn = "SELECT * FROM #{tablename} WHERE #{value_hash.keys[0]}='#{value_hash.values[0]}'"
    entry = $conn.exec(stmtn)
    return "use a unique field" if entry.count > 1
    entry[0]
end

def update_entry tablename, update_hash, identity_hash
    statement = "UPDATE #{tablename} SET #{update_hash.keys[0]}='#{update_hash.values[0]}' WHERE #{identity_hash.keys[0]}='#{identity_hash.values[0]}' "
    puts statement
    $conn.exec(statement)
end

get "/" do
   erb :home
end

get "/signup" do 
    erb :signup
end

post "/signup" do
    password = BCrypt::Password.create(params["password"])
    user_name = params["username"]
    add_entry "users", {"user_name" => user_name, "password" => password}

end

get "/users" do 
    users =  get_all_entries("users")
    users["users"].inspect
end

get "/login" do
    erb :login
end

get "/profile" do 
    user_name = session[:name]
    @user = get_entry('users', {"user_name" => user_name })
    erb :profile
    #erb :profile 
end

put "/upgrade" do
    identity_hash = {"user_name" => session[:name]}
    update_hash ={"role" => "tutor"} 
    update_entry("users", update_hash, identity_hash)
end

post "/login" do 
   user =  get_entry "users", {"user_name" => params["username"]}
   password = BCrypt::Password.new(user["password"])
   if password== params["password"]
    session[:name] = user["user_name"]
    redirect "/profile"
   else
    erb :error
   end
end


