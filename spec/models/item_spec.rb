require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Business Intelligence Endpoints' do
    describe '/api/v1/items/most_revenue?quantity=x' do
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

        expect(response_data.count).to eq(3)
        expect(response_data.first["name"]).to eq(item3.name)
        expect(response_data.last["name"]).to eq(item1.name)
        expect(response_data[1]["name"]).to eq(item2.name)
      end
    end
  end
end
