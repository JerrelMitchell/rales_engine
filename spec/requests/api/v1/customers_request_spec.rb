require 'rails_helper'
describe "Customers API" do
  it "sends a list of customers" do
    create_list(:customer, 3)

    get '/api/v1/customers.json'

    customers = JSON.parse(response.body)


    expect(response).to be_successful
    expect(customers.count).to eq(3)
  end


#
#   it "sends a one specific merchant" do
#
#     id = create(:merchant).id
#
#     get "/api/v1/merchants/#{id}.json"
#
#     merchant = JSON.parse(response.body)
#
#
#     expect(response).to be_successful
#     expect(merchant["id"]).to eq(id)
#     expect(merchant["name"]).to eq('King Soopers')
#   end
#
#   it "sends a merchant with find method with name params" do
#
#     name = create(:merchant).name
#
#     get "/api/v1/merchants/find?name=#{name}"
#
#     merchant = JSON.parse(response.body)
#
#
#     expect(response).to be_successful
#     expect(merchant["name"]).to eq(name)
#     expect(merchant["name"]).to eq('King Soopers')
#   end
#
#   it "sends a merchant with find method with name params downcased" do
#
#     name = create(:merchant).name
#
#     get "/api/v1/merchants/find?name=#{name.downcase}"
#
#     merchant = JSON.parse(response.body)
#
#
#     expect(response).to be_successful
#     expect(merchant["name"]).to eq(name)
#     expect(merchant["name"]).to eq('King Soopers')
#   end
#
#   it "sends a merchant with find method with id params" do
#
#     id = create(:merchant).id
#
#     get "/api/v1/merchants/find?id=#{id}"
#
#     merchant = JSON.parse(response.body)
#
#
#     expect(response).to be_successful
#     expect(merchant["id"]).to eq(id)
#   end
#
#   xit "sends a merchant with find method with created at params" do
#
#     created_at = "2012-03-27 14:54:09"
#     updated_at = "2012-03-27 14:54:09"
#
#     merchant = Merchant.create(name: 'manoj', created_at: created_at, updated_at: updated_at)
#
#     get "/api/v1/merchants/find?created_at=#{created_at}"
#
#     merchant = JSON.parse(response.body)
#
#
#     expect(response).to be_successful
#     expect(merchant["created_at"]).to eq(created_at)
#   end
#
#   it "sends all merchants with find all  method with name params" do
#
#     create_list(:merchant, 3)
#     name = Merchant.last.name
#
#     get "/api/v1/merchants/find_all?name=#{name}"
#
#     merchants = JSON.parse(response.body)
#
#
#     expect(response).to be_successful
#     expect(merchants.count).to eq(3)
#     expect(merchants.first["name"]).to eq(name)
#   end
#
#   it "sends all merchants with find all  method with name params" do
#
#     create_list(:merchant, 1)
#     name = Merchant.last.name
#
#     get "/api/v1/merchants/find_all?name=#{name}"
#
#     merchants = JSON.parse(response.body)
#
#
#     expect(response).to be_successful
#     expect(merchants.count).to eq(1)
#     expect(merchants.first["name"]).to eq(name)
#   end
#   it "sends a random merchant" do
#
#     create_list(:merchant, 1)
#     name = Merchant.first.name
#
#     get "/api/v1/merchants/random.json"
#
#     merchant = JSON.parse(response.body)
#
#
#     expect(response).to be_successful
#     expect(merchant["name"]).to eq(name)
#   end
#
#   it "sends all items for a merchant" do
#     merchant1 = Merchant.create(name: "Manoj")
#     merchant2 = Merchant.create(name: "Jerrel")
#     merchant1.items.create(name: "Twix")
#     merchant1.items.create(name: "M&Ms")
#     merchant2.items.create(name: "Failure")
#     merchant2.items.create(name: "Failure2")
#
#     get "/api/v1/merchants/#{merchant1.id}/items"
#
#     items = JSON.parse(response.body)
#
#     expect(response).to be_successful
#     expect(items.count).to eq(2)
#     expect(items.first["name"]).to eq("Twix")
#     expect(items.last["name"]).to_not eq("Failure2")
#   end
end
