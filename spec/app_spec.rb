require "spec_helper"

describe "My Sinatra Application" do
  it "should allow accessing signup" do
    get '/signup'
    # Rspec 2.x

    expect(last_response.status).to eq 200

  end
end