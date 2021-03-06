require 'rails_helper'

describe "Invoices API" do
  it "returns a list of invoices" do
    create_list(:invoice, 3)

    get '/api/v1/invoices.json'

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices.count).to eq(3)
  end

  it "returns a specific invoice" do
    new_invoice = create(:invoice)
    id = new_invoice.id
    status = new_invoice.status

    get "/api/v1/invoices/#{id}.json"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["id"]).to eq(id)
    expect(invoice["status"]).to eq(status)
  end

  it "returns an invoice with find method with id params" do
    id = create(:invoice).id

    get "/api/v1/invoices/find?id=#{id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["id"]).to eq(id)
  end

  it "returns an invoice with find method with customer id params" do
    customer_id = create(:invoice).customer_id

    get "/api/v1/invoices/find?customer_id=#{customer_id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["customer_id"]).to eq(customer_id)
  end

  it "returns an invoice with find method with merchant id params" do
    merchant_id = create(:invoice).merchant_id

    get "/api/v1/invoices/find?merchant_id=#{merchant_id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["merchant_id"]).to eq(merchant_id)
  end

  it "returns an invoice with find method with case insensitive status params" do
    status = create(:invoice).status

    get "/api/v1/invoices/find?status=#{status}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["status"]).to eq(status)

    get "/api/v1/invoices/find?status=#{status.upcase}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["status"]).to eq(status)

    get "/api/v1/invoices/find?status=#{status.downcase}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["status"]).to eq(status)
  end

  it "can search a single invoice by valid timestamps" do

    created_at = "2012-03-27 14:54:09"
    updated_at = "2012-03-27 14:54:09"
    merchant = Merchant.create!
    customer = Customer.create(first_name: 'manoj',last_name: 'panta', created_at: created_at, updated_at: updated_at)
    invoice = Invoice.create!(created_at: created_at, updated_at: updated_at, customer: customer, merchant: merchant )


    get "/api/v1/invoices/find?created_at=#{created_at}"

    invoice1 = JSON.parse(response.body)


    expect(response).to be_successful
    expect(invoice1["id"]).to eq(invoice.id)
  end

  it "returns all invoices with status params" do
    new_invoices = create_list(:invoice, 3)
    status = new_invoices.first.status

    get "/api/v1/invoices/find_all?status=#{status}"

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices.count).to eq(3)
    expect(invoices.first["status"]).to eq(status)
  end

  it "returns all invoices with customer_id params" do
    new_invoices = create_list(:invoice, 3)
    customer_id = new_invoices.first.customer_id

    get "/api/v1/invoices/find_all?customer_id=#{customer_id}"

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices.count).to eq(1)
    expect(invoices.first["customer_id"]).to eq(customer_id)
  end

  it "returns all invoices with merchant_id params" do
    new_invoices = create_list(:invoice, 3)
    merchant_id = new_invoices.first.merchant_id

    get "/api/v1/invoices/find_all?merchant_id=#{merchant_id}"

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices.count).to eq(1)
    expect(invoices.first["merchant_id"]).to eq(merchant_id)
  end

  it "returns a random invoice" do
    new_invoice = create(:invoice)
    status = new_invoice.status

    get "/api/v1/invoices/random.json"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["status"]).to eq(status)
  end

  it "returns all the transactions for an invoice" do
    merchant = Merchant.create
    customer = Customer.create
    invoice = merchant.invoices.create(customer: customer)
    transaction_id = Transaction.create(invoice: invoice).id

    get "/api/v1/invoices/#{Invoice.last.id}/transactions"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions.first["id"]).to eq(transaction_id)
  end

  it "returns all the invoice items for an invoice" do
    merchant = Merchant.create
    customer = Customer.create
    item = Item.create

    invoice = merchant.invoices.create(customer: customer)

    invoice_item = InvoiceItem.create(invoice: invoice, item: item)
    InvoiceItem.create(invoice: invoice, item: item)
    invoice_item2 = InvoiceItem.create(invoice: invoice, item: item)

    get "/api/v1/invoices/#{Invoice.last.id}/invoice_items"

    invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_items.count).to eq(3)
    expect(invoice_items.first["id"]).to eq(invoice_item.id)
    expect(invoice_items.last["id"]).to eq(invoice_item2.id)
  end

  it "returns all the items for an invoice" do
    merchant = Merchant.create
    customer = Customer.create
    item1 = merchant.items.create(name: "Option1", description: "This is an option", unit_price: 100)
    item2 = merchant.items.create(name: "Option2", description: "This is another option", unit_price: 200)
    item3 = merchant.items.create(name: "Option3", description: "This is the last option", unit_price: 300)
    invoice = merchant.invoices.create(customer: customer, merchant: merchant)
    invoice.invoice_items.create!(item: item1)
    invoice.invoice_items.create!(item: item2)
    invoice.invoice_items.create!(item: item3)

    get "/api/v1/invoices/#{invoice.id}/items"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items.count).to eq(3)
    expect(items.first["id"]).to eq(item1.id)
    expect(items.last["id"]).to eq(item3.id)
  end

  it "returns associated customer for an invoice" do
    merchant = Merchant.create
    customer = Customer.create

    invoice = merchant.invoices.create(customer: customer)

    get "/api/v1/invoices/#{invoice.id}/customer"

    customer1 = JSON.parse(response.body)

    expect(response).to be_successful

    expect(customer1["id"]).to eq(customer.id)
  end

  it "returns associated merchant for an invoice" do
    merchant = Merchant.create
    customer = Customer.create

    invoice = merchant.invoices.create(customer: customer)

    get "/api/v1/invoices/#{invoice.id}/merchant"

    merchant1 = JSON.parse(response.body)

    expect(response).to be_successful

    expect(merchant1["id"]).to eq(merchant.id)
  end
end
