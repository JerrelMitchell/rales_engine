require 'rails_helper'
describe "Customers API" do
  it "sends a list of customers" do
    create_list(:customer, 3)

    get '/api/v1/customers.json'

    customers = JSON.parse(response.body)


    expect(response).to be_successful
    expect(customers.count).to eq(3)
  end

  it "sends a one specific customer" do

    id = create(:customer).id

    get "/api/v1/customers/#{id}.json"

    customer = JSON.parse(response.body)


    expect(response).to be_successful
    expect(customer["id"]).to eq(id)
    expect(customer["first_name"]).to eq('Manoj')
  end

  it "sends a customer with find method with first name params" do

    name = create(:customer).first_name

    get "/api/v1/customers/find?first_name=#{name}"

    customer = JSON.parse(response.body)


    expect(response).to be_successful
    expect(customer["first_name"]).to eq(name)
    expect(customer["first_name"]).to eq('Manoj')
  end

  it "sends a customer with find method with last name params" do

    name = create(:customer).last_name

    get "/api/v1/customers/find?last_name=#{name}"

    customer = JSON.parse(response.body)


    expect(response).to be_successful
    expect(customer["last_name"]).to eq(name)
    expect(customer["last_name"]).to eq('Panta')
  end

  it "sends a customer with find method with name params downcased" do

    first_name = create(:customer).first_name

    get "/api/v1/customers/find?first_name=#{first_name.downcase}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["first_name"]).to eq(first_name)
    expect(customer["first_name"]).to eq('Manoj')
  end

  it "sends a customer with find method with id params" do

    id = create(:customer).id

    get "/api/v1/customers/find?id=#{id}"

    customer = JSON.parse(response.body)


    expect(response).to be_successful
    expect(customer["id"]).to eq(id)
  end

  # xit "sends a customer with find method with created at params" do
  #
  #   created_at = "2012-03-27 14:54:09"
  #   updated_at = "2012-03-27 14:54:09"
  #
  #   customer = Customer.create(first_name: 'manoj',last_name: 'panta' created_at: created_at, updated_at: updated_at)
  #
  #   get "/api/v1/customers/find?created_at=#{created_at}"
  #
  #   customer = JSON.parse(response.body)
  #
  #
  #   expect(response).to be_successful
  #   expect(customer["created_at"]).to eq(created_at)
  # end

  it "sends all customers with find all  method with name params" do

    create_list(:customer, 3)
    name = Customer.last.first_name

    get "/api/v1/customers/find_all?first_name=#{name}"

    customers = JSON.parse(response.body)


    expect(response).to be_successful
    expect(customers.count).to eq(3)
    expect(customers.first["first_name"]).to eq(name)
  end
#
#   it "sends allcustomers with find all  method with name params" do
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
