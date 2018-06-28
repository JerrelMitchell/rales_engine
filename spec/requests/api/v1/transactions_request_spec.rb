require 'rails_helper'
describe "transactions API" do
  it "returns a list of transactions" do
    create_list(:transaction, 3)

    get '/api/v1/transactions.json'

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions.count).to eq(3)
  end


  it "returns a one specific transaction" do
    id = create(:transaction).id

    get "/api/v1/transactions/#{id}.json"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["id"]).to eq(id)
    expect(transaction["result"]).to eq('successful')
  end

  it "returns a transaction with find method with credit_card_number params" do
    credit_card_number = create(:transaction).credit_card_number.to_s

    get "/api/v1/transactions/find?credit_card_number=#{credit_card_number}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["credit_card_number"]).to eq(credit_card_number.to_s)
  end

  it "returns all transactions with find all method with invoice_id params" do
    create_list(:transaction, 3)

    invoice_id = Transaction.first.invoice_id

    get "/api/v1/transactions/find_all?invoice_id=#{invoice_id}"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions.count).to eq(1)
    expect(transactions.first["invoice_id"]).to eq(invoice_id)
    expect(transactions.last["invoice_id"]).to eq(invoice_id)
  end

  it "returns all transactions with find all method with result params" do
    create_list(:transaction, 3)

    result = Transaction.first.result

    get "/api/v1/transactions/find_all?result=#{result}"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions.count).to eq(3)
    expect(transactions.first["result"]).to eq(result)
    expect(transactions.last["result"]).to eq(result)
  end

  it "returns all transactions with find all method with credit_card_number params" do
    create_list(:transaction, 3)

    credit_card_number = Transaction.first.credit_card_number.to_s

    get "/api/v1/transactions/find_all?credit_card_number=#{credit_card_number}"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions.count).to eq(3)
    expect(transactions.first["credit_card_number"]).to eq(credit_card_number.to_s)
    expect(transactions.last["credit_card_number"]).to eq(credit_card_number.to_s)
  end

  it "returns a random transaction" do
    create_list(:transaction, 1)
    credit_card_number = Transaction.first.credit_card_number.to_s

    get "/api/v1/transactions/random.json"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["credit_card_number"]).to eq(credit_card_number.to_s)
  end

  it "returns associated invoice for a transaction" do
    customer = Customer.create
    merchant = Merchant.create!
    invoice = customer.invoices.create!(merchant: merchant)
    transaction = invoice.transactions.create!

    get "/api/v1/transactions/#{transaction.id}/invoice"

    invoice1 = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice1["id"]).to eq(invoice.id)
  end
end
