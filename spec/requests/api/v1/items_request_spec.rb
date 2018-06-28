require 'rails_helper'

describe "Items API" do
  it "returns a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items.count).to eq(3)
  end

  it "returns a single item with its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["id"]).to eq(id)
  end

  it "can search a single item by valid id" do
    new_item = create(:item)

    get "/api/v1/items/find?id=#{new_item.id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["id"]).to eq(new_item.id)
  end

  it "can search a single item by case insensitive name" do
    new_item = create(:item)

    get "/api/v1/items/find?name=#{new_item.name}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["name"]).to eq(new_item.name)

    get "/api/v1/items/find?name=#{new_item.name.downcase}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["name"]).to eq(new_item.name)

    get "/api/v1/items/find?name=#{new_item.name.upcase}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["name"]).to eq(new_item.name)
  end

  it "can search a single item by valid description" do
    new_item = create(:item)

    get "/api/v1/items/find?description=Chocolate Candy"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["description"]).to eq(new_item.description)
  end

  it "can search a single item by valid unit price" do
    new_item = create(:item)

    get "/api/v1/items/find?unit_price=100"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["unit_price"]).to eq(Money.new(new_item.unit_price).to_s)
  end

  it "can search a single item by valid timestamps" do
    new_item = create(:item, created_at: "2012-03-27 14:53:59", updated_at: "2012-03-27 14:53:59")

    get "/api/v1/items/find?created_at=#{new_item.created_at}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["id"]).to eq(new_item.id)
    expect(item["name"]).to eq(new_item.name)
  end

  it "finds all items with same name" do
    new_items = create_list(:item, 3)

    get "/api/v1/items/find_all?name=Twix"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items.count).to eq(3)
    expect(items.first["name"]).to eq(new_items.first.name)
  end

  it "finds all items with same name" do
    new_items = create_list(:item, 3)

    get "/api/v1/items/find_all?name=Twix"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items.count).to eq(3)
    expect(items.first["name"]).to eq(new_items.first.name)
  end

  it "finds all items with same description" do
    new_items = create_list(:item, 3)

    get "/api/v1/items/find_all?description=#{new_items.first.description}"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items.count).to eq(3)
    expect(items.first["description"]).to eq(new_items.first.description)
  end

  it "finds all items with same unit price" do
    new_items = create_list(:item, 3)

    get "/api/v1/items/find_all?unit_price=#{new_items.first.unit_price}"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items.count).to eq(3)
    expect(items.first["unit_price"]).to eq(Money.new(new_items.first.unit_price).to_s)
  end

  it "finds all items with same merchant id" do
    new_items = create_list(:item, 3)

    get "/api/v1/items/find_all?merchant_id=#{new_items.first.merchant_id}"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items.count).to eq(1)
    expect(items.first["merchant_id"]).to eq(new_items.first.merchant_id)
  end

  it "returns a random item" do
    new_items = create_list(:item, 3)

    get "/api/v1/items/random"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["name"]).to eq(new_items.first.name)
  end

  it "returns single merchant associated with an item" do
    merchant1 = Merchant.create(name: "Manoj")
    Merchant.create(name: "Jerrel")
    item1 = merchant1.items.create(name: "Twix")

    get "/api/v1/items/#{item1.id}/merchant"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["name"]).to eq("Manoj")
  end

  it "returns all invoice_items associated with an item" do
    merchant = Merchant.create(name: "Manoj")
    customer = Customer.create(first_name: "Jerrel", last_name: "Mitchell")
    invoice = Invoice.create(merchant: merchant, customer: customer, status: "pending")
    item = merchant.items.create(name: "Twix")
    invoice_item1 = InvoiceItem.create(invoice: invoice, item: item, quantity: 1, unit_price: 200)
    InvoiceItem.create(invoice: invoice, item: item, quantity: 3, unit_price: 500)
    invoice_item3 = InvoiceItem.create(invoice: invoice, item: item, quantity: 2, unit_price: 800)

    get "/api/v1/items/#{item.id}/invoice_items"

    invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_items.count).to eq(3)
    expect(invoice_items.first["id"]).to eq(invoice_item1.id)
    expect(invoice_items.last["id"]).to eq(invoice_item3.id)
  end

  it 'should return a collection of items with most revenue ranked by total revenue' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoices = create_list(:invoice, 5, merchant: merchant, customer: customer)
    item1 = merchant.items.create!(name: "Example1", description: "I can't believe it's not butter!", unit_price: 100, merchant_id: merchant.id)
    item2 = merchant.items.create!(name: "Example2", description: "I can't believe it's not butter!", unit_price: 200, merchant_id: merchant.id)
    item3 = merchant.items.create!(name: "Example3", description: "I can't believe it's not butter!", unit_price: 700, merchant_id: merchant.id)
    item4 = merchant.items.create!(name: "Example4", description: "I can't believe it's not butter!", unit_price: 100, merchant_id: merchant.id)
    create(:invoice_item, item: item1, unit_price: item1.unit_price, quantity: 5, invoice: invoices[0])
    create(:invoice_item, item: item2, unit_price: item2.unit_price, quantity: 5, invoice: invoices[1])
    create(:invoice_item, item: item3, unit_price: item3.unit_price, quantity: 5, invoice: invoices[2])
    create(:invoice_item, item: item4, unit_price: item4.unit_price, quantity: 5, invoice: invoices[3])
    create(:transaction, invoice: invoices[0])
    create(:transaction, invoice: invoices[1])
    create(:transaction, invoice: invoices[2])
    create(:transaction, invoice: invoices[3], result: "failed")

    get '/api/v1/items/most_revenue?quantity=4'

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items.count).to eq(3)
    expect(items.first["name"]).to eq(item3.name)
    expect(items.last["name"]).to eq(item1.name)
    expect(items[1]["name"]).to eq(item2.name)
  end

  it 'should return best day for a item based on paid invoices count ' do
    merchant = Merchant.create(name: "King Soopers")

    customer = Customer.create()

    item = merchant.items.create!

    invoice = merchant.invoices.create!(customer: customer, created_at:'2012-03-25 09:54:09 UTC', updated_at: '2012-03-25 09:54:09 UTC' )
    invoice_item1 = invoice.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice.transactions.create!(result: 'success')

    invoice1 = merchant.invoices.create!(customer: customer, created_at:'2012-03-25 09:54:09 UTC', updated_at: '2012-03-25 09:54:09 UTC' )
    invoice_item1 = invoice1.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice1.transactions.create!(result: 'success')

    invoice2 = merchant.invoices.create!(customer: customer, created_at:'2012-03-25 09:54:09 UTC', updated_at: '2012-03-25 09:54:09 UTC' )
    invoice_item2 = invoice2.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice2.transactions.create!(result: 'success')

    invoice3 = merchant.invoices.create!(customer: customer, created_at:'2012-04-25 09:54:09 UTC', updated_at: '2012-04-25 09:54:09 UTC' )
    invoice_item3 = invoice3.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice3.transactions.create!(result: 'success')

    invoice4 = merchant.invoices.create!(customer: customer, created_at:'2012-04-25 09:54:09 UTC', updated_at: '2012-04-25 09:54:09 UTC' )
    invoice_item1 = invoice4.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice4.transactions.create!(result: 'success')

    get "/api/v1/items/#{item.id}/best_day"

    best_day = JSON.parse(response.body)

    expect(response).to be_successful
    expect(best_day.count).to eq(1)
    expect(best_day['updated_at']).to eq(invoice.created_at)
  end
end
