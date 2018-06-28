# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# RESULT = ["success", "failed"]
#
# merchant = Merchant.create!(id: 1000, name: "Example Shop")
# customer = Customer.create!(first_name: "Dude", last_name: "Wow")
#
# 10.times do
#   merchant.items.create!(
#     name: Faker::Commerce.product_name,
#     description: Faker::WorldOfWarcraft.quote,
#     unit_price: rand(100..10000)
#   )
# end
#
# 10.times do
#   merchant.invoices.create!(status: "shipped", customer: customer)
# end
#
# 100.times do
#   InvoiceItem.create!(
#     item_id: rand(1..10),
#     invoice_id: rand(1..10),
#     quantity: rand(1..10),
#   )
# end
#
# 100.times do
#   Transaction.create!(
#     invoice_id: rand(1..10),
#     credit_card_number: (0000000000..9999999999),
#     result: RESULT.sample
#   )
# end
