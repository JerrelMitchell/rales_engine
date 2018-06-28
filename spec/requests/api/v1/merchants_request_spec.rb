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
    expect(revenue["revenue"]).to eq("112.00")
  end

  it "returns revenue for a merchant for a specific date" do

    merchant = Merchant.create(name: "King Soopers")
    customer = Customer.create()

    invoice = merchant.invoices.create!(customer: customer)
    item = Item.create!(merchant: merchant)
    invoice_item = invoice.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice_item = invoice.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice.transactions.create!(result: 'success')

    get "/api/v1/merchants/#{merchant.id}/revenue?date=#{(invoice.created_at)}"

    revenue = JSON.parse(response.body)

    expect(response).to be_successful
    expect(revenue["revenue"]).to eq("112.00")
  end

  it "returns quantity[NUMBER] of merchants that sold most items" do
    merchant = Merchant.create(name: "King Soopers")
    merchant1 = Merchant.create(name: 'walmart')
    merchant2 = Merchant.create(name: 'Costco')

    customer = Customer.create()

    item = merchant.items.create!
    item1 = merchant.items.create!
    item2 = merchant.items.create!

    item3 = merchant1.items.create!
    item4 = merchant1.items.create!
    item5 = merchant1.items.create!

    item6 = merchant2.items.create!
    item7 = merchant2.items.create!
    item8 = merchant2.items.create!

    item3 = merchant1.items.create!

    invoice = merchant.invoices.create!(customer: customer)
    invoice_item1 = invoice.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice_item2 = invoice.invoice_items.create!(item: item1, quantity: 4, unit_price: 1400)
    invoice_item3 = invoice.invoice_items.create!(item: item2, quantity: 4, unit_price: 1400)
    invoice.transactions.create!(result: 'success')

    invoice1 = merchant1.invoices.create!(customer: customer)
    invoice_item4 = invoice1.invoice_items.create!(item: item3, quantity: 2, unit_price: 1400)
    invoice_item5 = invoice1.invoice_items.create!(item: item4, quantity: 2, unit_price: 1400)
    invoice_item6 = invoice1.invoice_items.create!(item: item5, quantity: 2, unit_price: 1400)
    invoice1.transactions.create!(result: 'success')

    invoice2 = merchant2.invoices.create!(customer: customer)
    invoice_item7 = invoice2.invoice_items.create!(item: item6, quantity: 1, unit_price: 1400)
    invoice_item8 = invoice2.invoice_items.create!(item: item7, quantity: 1, unit_price: 1400)
    invoice_item9 = invoice2.invoice_items.create!(item: item8, quantity: 1, unit_price: 1400)
    invoice2.transactions.create!(result: 'success')



    get "/api/v1/merchants/most_items?quantity=2"

    merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchants.count).to eq(2)
    expect(merchants.first['name']).to eq(merchant.name)
    expect(merchants.last['name']).to eq(merchant1.name)
  end

  it "returns favorite customer for a merchant" do
    merchant = Merchant.create!(name: "King Soopers")

    customer = Customer.create!(first_name: 'Manoj', last_name: 'Panta')
    customer1 = Customer.create!(first_name: 'Jerrel', last_name: 'Mitchell')


    item = merchant.items.create!
    item1 = merchant.items.create!
    item2 = merchant.items.create!

    invoice = merchant.invoices.create!(customer: customer)
    invoice_item1 = invoice.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice_item2 = invoice.invoice_items.create!(item: item1, quantity: 4, unit_price: 1400)
    invoice_item3 = invoice.invoice_items.create!(item: item2, quantity: 4, unit_price: 1400)
    invoice.transactions.create!(result: 'success')

    invoice1 = merchant.invoices.create!(customer: customer)
    invoice_item4 = invoice1.invoice_items.create!(item: item, quantity: 2, unit_price: 1400)
    invoice_item5 = invoice1.invoice_items.create!(item: item1, quantity: 2, unit_price: 1400)
    invoice_item6 = invoice1.invoice_items.create!(item: item2, quantity: 2, unit_price: 1400)
    invoice1.transactions.create!(result: 'success')

    invoice2 = merchant.invoices.create!(customer: customer)
    invoice_item7 = invoice2.invoice_items.create!(item: item, quantity: 1, unit_price: 1400)
    invoice_item8 = invoice2.invoice_items.create!(item: item1, quantity: 1, unit_price: 1400)
    invoice_item9 = invoice2.invoice_items.create!(item: item2, quantity: 1, unit_price: 1400)
    invoice2.transactions.create!(result: 'success')

    invoice3 = merchant.invoices.create!(customer: customer1)
    invoice_item10 = invoice2.invoice_items.create!(item: item, quantity: 1, unit_price: 1400)
    invoice_item11 = invoice2.invoice_items.create!(item: item1, quantity: 1, unit_price: 1400)
    invoice_item12 = invoice2.invoice_items.create!(item: item2, quantity: 1, unit_price: 1400)
    invoice3.transactions.create!(result: 'success')

    invoice4 = merchant.invoices.create!(customer: customer1)
    invoice_item10 = invoice2.invoice_items.create!(item: item, quantity: 1, unit_price: 1400)
    invoice_item11 = invoice2.invoice_items.create!(item: item1, quantity: 1, unit_price: 1400)
    invoice_item12 = invoice2.invoice_items.create!(item: item2, quantity: 1, unit_price: 1400)
    invoice4.transactions.create!(result: 'success')



    get "/api/v1/merchants/#{merchant.id}/favorite_customer"

    favorite_customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(favorite_customer['first_name']).to eq(customer.first_name)
    expect(favorite_customer['last_name']).to eq(customer.last_name)
  end

  it 'returns most revenue for quantity[NUMBER] of merchants' do
    merchant = Merchant.create(name: "King Soopers")
    merchant1 = Merchant.create(name: 'walmart')
    merchant2 = Merchant.create(name: 'Costco')

    customer = Customer.create()

    item = merchant.items.create!
    item1 = merchant.items.create!
    item2 = merchant.items.create!

    merchant1.items.create!
    item4 = merchant1.items.create!
    item5 = merchant1.items.create!

    item6 = merchant2.items.create!
    item7 = merchant2.items.create!
    item8 = merchant2.items.create!

    item3 = merchant1.items.create!

    invoice = merchant.invoices.create!(customer: customer)
    invoice.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice.invoice_items.create!(item: item1, quantity: 4, unit_price: 1400)
    invoice.invoice_items.create!(item: item2, quantity: 4, unit_price: 1400)
    invoice.transactions.create!(result: 'success')

    invoice1 = merchant1.invoices.create!(customer: customer)
    invoice1.invoice_items.create!(item: item3, quantity: 2, unit_price: 1400)
    invoice1.invoice_items.create!(item: item4, quantity: 2, unit_price: 1400)
    invoice1.invoice_items.create!(item: item5, quantity: 2, unit_price: 1400)
    invoice1.transactions.create!(result: 'success')

    invoice2 = merchant2.invoices.create!(customer: customer)
    invoice2.invoice_items.create!(item: item6, quantity: 1, unit_price: 1400)
    invoice2.invoice_items.create!(item: item7, quantity: 1, unit_price: 1400)
    invoice2.invoice_items.create!(item: item8, quantity: 1, unit_price: 1400)
    invoice2.transactions.create!(result: 'success')

    get "/api/v1/merchants/most_revenue?quantity=2"

    merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchants.count).to eq(2)
    expect(merchants.first["id"]).to eq(merchant.id)
    expect(merchants.first["name"]).to eq(merchant.name)
    expect(merchants.last["id"]).to eq(merchant1.id)
    expect(merchants.last["name"]).to eq(merchant1.name)
  end

  it 'returns revenue for specified date' do
    merchant = Merchant.create(name: "King Soopers")

    customer = Customer.create()

    item = merchant.items.create!

    invoice = merchant.invoices.create!(customer: customer, created_at:'2012-03-22 03:55:09 UTC', updated_at: '2012-03-22 03:55:09 UTC' )
    invoice_item1 = invoice.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice.transactions.create!(result: 'success')

    invoice1 = merchant.invoices.create!(customer: customer, created_at:'2012-03-22 03:55:09 UTC', updated_at: '2012-03-22 03:55:09 UTC' )
    invoice_item1 = invoice1.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice1.transactions.create!(result: 'success')

    invoice2 = merchant.invoices.create!(customer: customer, created_at:'2012-03-22 03:55:09 UTC', updated_at: '2012-03-22 03:55:09 UTC' )
    invoice_item2 = invoice2.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice2.transactions.create!(result: 'success')

    invoice3 = merchant.invoices.create!(customer: customer, created_at:'2012-04-25 09:54:09 UTC', updated_at: '2012-04-25 09:54:09 UTC' )
    invoice_item3 = invoice3.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice3.transactions.create!(result: 'success')

    invoice4 = merchant.invoices.create!(customer: customer, created_at:'2012-04-25 09:54:09 UTC', updated_at: '2012-04-25 09:54:09 UTC' )
    invoice_item1 = invoice4.invoice_items.create!(item: item, quantity: 4, unit_price: 1400)
    invoice4.transactions.create!(result: 'success')

    get "/api/v1/merchants/revenue?date=#{invoice.created_at}"

    revenue = JSON.parse(response.body)

    expect(response).to be_successful
    expect(revenue).to eq("168.00")
  end
end
