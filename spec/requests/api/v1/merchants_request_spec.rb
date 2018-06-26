require 'rails_helper'
describe "Items API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants.json'

    merchants = JSON.parse(response.body)


    expect(response).to be_successful
    expect(merchants.count).to eq(3)
  end

  it "sends a one specific merchant" do

    id = create(:merchant).id

    get "/api/v1/merchants/#{id}.json"

    merchant = JSON.parse(response.body)


    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
    expect(merchant["name"]).to eq('King Soopers')
  end

  it "sends a merchant with find method with name params" do

    name = create(:merchant).name

    get "/api/v1/merchants/find?name=#{name}.json"

    merchant = JSON.parse(response.body)


    expect(response).to be_successful
    expect(merchant["name"]).to eq(name)
    expect(merchant["name"]).to eq('King Soopers')
  end
end
