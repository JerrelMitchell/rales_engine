require 'rails_helper'
describe "Items API" do
  it "returns a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants.json'

    merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchants.count).to eq(3)
  end

  it "returns a one specific merchant" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}.json"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
    expect(merchant["name"]).to eq('King Soopers')
  end

  it "returns a merchant with find method with name params" do
    new_merchant = create(:merchant)

    get "/api/v1/merchants/find?name=#{new_merchant.name}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["name"]).to eq(new_merchant.name)
    expect(merchant["name"]).to eq('King Soopers')

    get "/api/v1/merchants/find?name=#{new_merchant.name.downcase}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["name"]).to eq(new_merchant.name)
    expect(merchant["name"]).to eq('King Soopers')

    get "/api/v1/merchants/find?name=#{new_merchant.name.upcase}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["name"]).to eq(new_merchant.name)
    expect(merchant["name"]).to eq('King Soopers')
  end

  it "returns a merchant with find method with id params" do
    id = create(:merchant).id

    get "/api/v1/merchants/find?id=#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
  end

  it "can search a single merchant by valid timestamps" do
    created_at = "2012-03-27 14:54:09"
    updated_at = "2012-03-27 14:54:09"
    Merchant.create(name: 'manoj', created_at: created_at, updated_at: updated_at)

    get "/api/v1/merchants/find?created_at=#{created_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["name"]).to eq('manoj')
    expect(merchant["id"]).to eq(Merchant.last.id)
  end

  it "returns all merchants with find all method with name params" do
    new_merchants = create_list(:merchant, 3)

    get "/api/v1/merchants/find_all?name=#{new_merchants.first.name}"

    merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchants.count).to eq(3)
    expect(merchants.first["name"]).to eq(new_merchants.first.name)
    expect(merchants.last["name"]).to eq(new_merchants.last.name)
  end

  it "returns a random merchant" do
    create_list(:merchant, 1)
    name = Merchant.first.name

    get "/api/v1/merchants/random.json"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["name"]).to eq(name)
  end

  it "returns all items for a merchant" do
    merchant1 = Merchant.create(name: "Manoj")
    merchant2 = Merchant.create(name: "Jerrel")
    merchant1.items.create(name: "Twix")
    merchant1.items.create(name: "M&Ms")
    merchant2.items.create(name: "Failure")
    merchant2.items.create(name: "Failure2")

    get "/api/v1/merchants/#{merchant1.id}/items"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items.count).to eq(2)
    expect(items.first["name"]).to eq("Twix")
    expect(items.last["name"]).to_not eq("Failure2")
  end

  it "returns revenue for a merchant" do

    merchant = Merchant.create(name: "King Soopers")
    customer = Customer.create()

    invoice = merchant.invoices.create!(customer: customer)
    item = Item.create
    invoice_item = invoice.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice_item = invoice.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice.transactions.create!(result: 'success')

    get "/api/v1/merchants/#{merchant.id}/revenue"

    revenue = JSON.parse(response.body)

    expect(response).to be_successful
    expect(revenue).to eq(11200)
  end

  xit 'returns most revenue for x amount of merchants' do
    merchant1 = Merchant.create(name: "Manoj")
    merchant2 = Merchant.create(name: "Jerrel")
    merchant3 = Merchant.create(name: "Wow")
    customer1 = Customer.create(first_name: "Dude", last_name: "Bruh")
    item1 = merchant1.items.create(name: "M&Ms", unit_price: 300)
    item2 = merchant2.items.create(name: "Failure", unit_price: 1250)
    item3 = merchant2.items.create(name: "Failure2", unit_price: 5000)
    item4 = merchant1.items.create(name: "Twix", unit_price: 100)
    invoice1 = item1.invoices.create(customer: customer1, merchant: merchant1, status: 'successful')
    invoice2 = item2.invoices.create(customer: customer1, merchant: merchant2, status: 'successful')
    invoice3 = item3.invoices.create(customer: customer1, merchant: merchant1, status: 'cancelled')
    invoice4 = item4.invoices.create(customer: customer1, merchant: merchant2, status: 'cancelled')
    invoice_item1 = item1.invoice_items.create(invoice: invoice1, quantity: 1)
    invoice_item2 = item2.invoice_items.create(invoice: invoice2, quantity: 1)
    invoice_item3 = item3.invoice_items.create(invoice: invoice3, quantity: 1)
    invoice_item4 = item4.invoice_items.create(invoice: invoice4, quantity: 1)

    get "/api/v1/merchants/most_revenue?quantity=2"

    merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchants.count).to eq(2)
    expect(merchants.first["name"]).to eq(merchant2.name)
    expect(merchants.first["total_revenue"]).to eq(Money.new(invoice_items.unit_price).to_s)
    expect(merchants.last["name"]).to eq(merchant1.name)
    expect(merchants.last["total_revenue"]).to eq(invoice_items.unit_price)
  end
end
