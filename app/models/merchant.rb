class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items , through: :invoices


  def revenue
    invoices.select('sum(invoice_items.unit_price * invoice_items.quantity) as revenue')
    .joins(:invoice_items, :transactions)
    .where(transactions: {result: 'success'})[0].revenue
  end
end
