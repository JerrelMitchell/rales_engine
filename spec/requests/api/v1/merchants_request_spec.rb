require 'rails_helper'
describe "Items API" do
  it "sends a list of merchants" do
    create_list(:merchants, 3)

    get '/api/v1/items'

    expect(response).to be_successful
  end
end
