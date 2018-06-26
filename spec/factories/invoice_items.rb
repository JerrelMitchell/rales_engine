FactoryBot.define do
  factory :invoice_item do
    item
    invoice
    quantity 10
    unit_price 1500
  end
end
