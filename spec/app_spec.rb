require "spec_helper"

describe "My Sinatra Application" do
  it "should allow accessing signup" do
    get '/signup'
    # Rspec 2.x

    expect(last_response.status).to eq 200

  end
  it "should render login" do 
    get "/login"
    expect(last_response.status).to eq 200
  end
  it "should render redirect if not logged in" do
    get "/tutorial"
    expect(last_response.status).to eq 302
  end
  it "should render home" do
    get "/"
    expect(last_response.status).to eq 200
  end
  it "should redirect after succesful signup" do
    post "/signup", {"user_name" => "kevin", "password" => "test_password", "email" => "example@gmail.com"}
    expect(last_response.status).to eq 302
  end
end