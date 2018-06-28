require 'rails_helper'

describe "Customers API" do
  it "returns a list of customers" do
    create_list(:customer, 3)

    get '/api/v1/customers.json'

    customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customers.count).to eq(3)
  end

  it "returns a one specific customer" do
    id = create(:customer).id

    get "/api/v1/customers/#{id}.json"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["id"]).to eq(id)
    expect(customer["first_name"]).to eq('Manoj')
  end

  it "returns a customer with find method with first name params" do
    name = create(:customer).first_name

    get "/api/v1/customers/find?first_name=#{name}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["first_name"]).to eq(name)
    expect(customer["first_name"]).to eq('Manoj')
  end

  it "returns a customer with find method with last name params" do
    name = create(:customer).last_name

    get "/api/v1/customers/find?last_name=#{name}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["last_name"]).to eq(name)
    expect(customer["last_name"]).to eq('Panta')
  end

  it "returns a customer with find method with name params downcased" do
    first_name = create(:customer).first_name

    get "/api/v1/customers/find?first_name=#{first_name.downcase}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["first_name"]).to eq(first_name)
    expect(customer["first_name"]).to eq('Manoj')
  end

  it "returns a customer with find method with id params" do
    id = create(:customer).id

    get "/api/v1/customers/find?id=#{id}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["id"]).to eq(id)
  end

  it "can search a single customer by valid timestamps" do

    created_at = "2012-03-27 14:54:09"
    updated_at = "2012-03-27 14:54:09"

    customer = Customer.create(first_name: 'manoj',last_name: 'panta', created_at: created_at, updated_at: updated_at)

    get "/api/v1/customers/find?created_at=#{created_at}"

    customer1 = JSON.parse(response.body)


    expect(response).to be_successful
    expect(customer1["first_name"]).to eq(customer.first_name)
  end

  it "returns all customers with find all method with name params" do
    create_list(:customer, 3)
    name = Customer.last.first_name

    get "/api/v1/customers/find_all?first_name=#{name}"

    customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customers.count).to eq(3)
    expect(customers.first["first_name"]).to eq(name)
  end

  it "returns a random customer" do
    create_list(:customer, 1)

    name = Customer.first.first_name

    get "/api/v1/customers/random.json"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["first_name"]).to eq(name)
  end

  it "returns favorite merchant of a customer" do
    merchant = Merchant.create(name: "King Soopers")
    merchant1 = Merchant.create(name: 'walmart')
    merchant2 = Merchant.create(name: 'Costco')

    customer = Customer.create()


    invoice = merchant.invoices.create!(customer: customer)
    invoice1 = merchant.invoices.create!(customer: customer)
    invoice2 = merchant.invoices.create!(customer: customer)
    invoice3 = merchant.invoices.create!(customer: customer)

    invoice.transactions.create!(result: 'success')
    invoice1.transactions.create!(result: 'success')
    invoice2.transactions.create!(result: 'success')
    invoice3.transactions.create!(result: 'success')

    invoice4 = merchant1.invoices.create!(customer: customer)
    invoice5 = merchant1.invoices.create!(customer: customer)

    invoice4.transactions.create!(result: 'success')
    invoice5.transactions.create!(result: 'success')

    invoice6 = merchant2.invoices.create!(customer: customer)
    invoice7 = merchant2.invoices.create!(customer: customer)

    invoice6.transactions.create!(result: 'success')
    invoice7.transactions.create!(result: 'success')

    get "/api/v1/customers/#{customer.id}/favorite_merchant"

    favorite_merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(favorite_merchant['name']).to eq('King Soopers')
  end
end
