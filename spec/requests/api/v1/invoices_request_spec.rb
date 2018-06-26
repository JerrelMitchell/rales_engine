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

  # xit "returns an invoice with find method with created at params" do
  #
  #   created_at = "2012-03-27 14:54:09"
  #   updated_at = "2012-03-27 14:54:09"
  #
  #   invoice = Customer.create(first_name: 'manoj',last_name: 'panta' created_at: created_at, updated_at: updated_at)
  #
  #   get "/api/v1/invoices/find?created_at=#{created_at}"
  #
  #   invoice = JSON.parse(response.body)
  #
  #
  #   expect(response).to be_successful
  #   expect(invoice["created_at"]).to eq(created_at)
  # end

  it "returns all invoices with find all method with name params" do
    new_invoices = create_list(:invoice, 3)
    status = new_invoices.first.status

    get "/api/v1/invoices/find_all?status=#{status}"

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices.count).to eq(3)
    expect(invoices.first["status"]).to eq(status)
  end

  it "returns a random invoice" do
    new_invoice = create(:invoice)
    status = new_invoice.status

    get "/api/v1/invoices/random.json"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["status"]).to eq(status)
  end
end