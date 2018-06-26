require 'rails_helper'

describe "Invoice Items API" do
  it "sends a list of invoice_items" do
    create_list(:invoice_item, 3)

    get '/api/v1/invoice_items'

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)

    expect(invoice_items.count).to eq(3)
  end

  it "shows a single invoice_item with its id" do
    id = create(:invoice_item).id

    get "/api/v1/invoice_items/#{id}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["id"]).to eq(id)
  end

  it "can search a single invoice_item by valid id" do
    new_invoice_item = create(:invoice_item)

    get "/api/v1/invoice_items/find?id=#{new_invoice_item.id}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["id"]).to eq(new_invoice_item.id)
  end

  it "can search a single invoice_item by valid item id" do
    new_invoice_item = create(:invoice_item)

    get "/api/v1/invoice_items/find?name=Twix"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["item_id"]).to eq(new_invoice_item.item_id)
  end

  it "can search a single invoice_item by valid invoice id" do
    new_invoice_item = create(:invoice_item)

    get "/api/v1/invoice_items/find?description=Chocolate Candy"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["invoice_id"]).to eq(new_invoice_item.invoice_id)
  end

  it "can search a single invoice_item by valid unit price" do
    new_invoice_item = create(:invoice_item)

    get "/api/v1/invoice_items/find?unit_price=1500"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["unit_price"]).to eq(new_invoice_item.unit_price)
  end

  it "can search a single invoice_item by valid quantity" do
    new_invoice_item = create(:invoice_item)

    get "/api/v1/invoice_items/find?quantity=10"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["quantity"]).to eq(new_invoice_item.quantity)
  end

  xit "can search a single invoice_item by valid timestamps" do
    new_invoice_item = create(:invoice_item, created_at: "2012-03-27 14:53:59", updated_at: "2012-03-27 14:53:59")

    get "/api/v1/invoice_items/find?created_at=#{new_invoice_item.created_at}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["created_at"]).to eq(new_invoice_item.created_at)
    expect(invoice_item["updated_at"]).to eq(new_invoice_item.updated_at)
  end

  it "finds all invoice_items with same item id" do
    new_invoice_items = create_list(:invoice_item, 3)

    get "/api/v1/invoice_items/find_all?quantity=10"

    invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_items.count).to eq(3)
    expect(invoice_items.first["item_id"]).to eq(new_invoice_items.first.item_id)
  end

  it "returns a random invoice_item" do
    new_invoice_items = create_list(:invoice_item, 3)

    get "/api/v1/invoice_items/random"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["quantity"]).to eq(new_invoice_items.first.quantity)
  end
end
