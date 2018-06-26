require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items.count).to eq(3)
  end

  it "shows a single item with its id" do
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

  it "can search a single item by valid name" do
    new_item = create(:item)

    get "/api/v1/items/find?name=Twix"

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
    expect(item["unit_price"]).to eq(new_item.unit_price)
  end

  xit "can search a single item by valid timestamps" do
    new_item = create(:item, created_at: "2012-03-27 14:53:59", updated_at: "2012-03-27 14:53:59")

    get "/api/v1/items/find?created_at=#{new_item.created_at}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["created_at"]).to eq(new_item.created_at)
    expect(item["updated_at"]).to eq(new_item.updated_at)
  end

  it "finds all items with same name" do
    new_items = create_list(:item, 3)

    get "/api/v1/items/find_all?name=Twix"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items.count).to eq(3)
    expect(items.first["name"]).to eq(new_items.first.name)
  end

  it "returns a random item" do
    new_items = create_list(:item, 3)

    get "/api/v1/items/random"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["name"]).to eq(new_items.first.name)
  end

  it "sends merchant for an item" do
    merchant1 = Merchant.create(name: "Manoj")
    Merchant.create(name: "Jerrel")
    item1 = merchant1.items.create(name: "Twix")

    get "/api/v1/items/#{item1.id}/merchant"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["name"]).to eq("Manoj")
  end
end
