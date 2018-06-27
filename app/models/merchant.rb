class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items , through: :invoices


  def revenue
    invoices.select('sum(invoice_items.unit_price * invoice_items.quantity) as revenue')
    .joins(:invoice_items, :transactions)
    .where(transactions: {result: 'success'})[0].revenue
  end

  def revenue_for_a_date(date)
    invoices.select('sum(invoice_items.unit_price * invoice_items.quantity) as revenue')
    .joins(:invoice_items, :transactions)
    .where(transactions: {result: 'success'}, created_at: date.beginning_of_day..date.end_of_day)[0].revenue


  end
end
