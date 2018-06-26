require 'rails_helper'
describe "transactions API" do
  it "sends a list of transactions" do
    create_list(:transaction, 3)

    get '/api/v1/transactions.json'

    transactions = JSON.parse(response.body)


    expect(response).to be_successful
    expect(transactions.count).to eq(3)
  end


  it "sends a one specific transaction" do
    id = create(:transaction).id

    get "/api/v1/transactions/#{id}.json"

    transaction = JSON.parse(response.body)


    expect(response).to be_successful
    expect(transaction["id"]).to eq(id)
    expect(transaction["result"]).to eq('successful')
  end

  it "sends a transaction with find method with credit_card_number params" do

    credit_card_number = create(:transaction).credit_card_number


    get "/api/v1/transactions/find?credit_card_number=#{credit_card_number}"

    transaction = JSON.parse(response.body)


    expect(response).to be_successful
    expect(transaction["credit_card_number"]).to eq(credit_card_number)
  end


  it "sends all transactions with find all method with credit_card_number params" do

    create_list(:transaction, 3)

    credit_card_number = Transaction.first.credit_card_number

    get "/api/v1/transactions/find_all?credit_card_number=#{credit_card_number}"

    transactions = JSON.parse(response.body)


    expect(response).to be_successful
    expect(transactions.count).to eq(3)
    expect(transactions.first["credit_card_number"]).to eq(credit_card_number)
    expect(transactions.last["credit_card_number"]).to eq(credit_card_number)
  end


  it "sends a random transaction" do

    create_list(:transaction, 1)
    credit_card_number = Transaction.first.credit_card_number

    get "/api/v1/transactions/random.json"

    transaction = JSON.parse(response.body)


    expect(response).to be_successful
    expect(transaction["credit_card_number"]).to eq(credit_card_number)
  end

end