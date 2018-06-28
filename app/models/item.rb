class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :transactions, through: :invoices
  has_many :invoices, through: :invoice_items

  def self.best_sellers(quantity)
    select("items.*, sum(invoice_items.unit_price * invoice_items.quantity) AS revenue")
      .joins(invoices: [:invoice_items, :transactions])
      .where(transactions: {result: "success"})
      .group(:id)
      .order("revenue DESC")
      .limit(quantity)
  end

  def best_day
    invoices.select('invoices.*, count(invoices)as invoice_count')
    .joins(:invoice_items, :transactions)
    .where(transactions: {result: 'success'})
    .order('invoice_count DESC')
    .group(:id, :created_at)
    .limit(1)
    .first
    .created_at

  end
end
