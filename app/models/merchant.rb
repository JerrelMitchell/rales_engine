class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices


  def revenue
    invoices
      .select('SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue')
      .joins(:invoice_items, :transactions)
      .where(transactions: { result: 'success' })[0]
      .revenue
  end

  def revenue_for_a_date(date)
    invoices
      .select('SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue')
      .joins(:invoice_items, :transactions)
      .where(transactions: { result: 'success' }, created_at: date.beginning_of_day..date.end_of_day)[0]
      .revenue
  end

  def self.most_revenue(quantity)
    select("merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
      .joins(invoices: [:invoice_items, :transactions])
      .where(transactions: { result: "success" })
      .group(:id)
      .order("revenue DESC")
      .limit(quantity)
  end

  def self.most_items(quantity)
    select('merchants.*, SUM(invoice_items.quantity) AS total_item_sold')
      .joins(invoices: [:invoice_items, :transactions])
      .where(transactions: { result: 'success' })
      .group(:id)
      .order('total_item_sold DESC')
      .limit(quantity)
  end

  def favorite_customer
    customers
      .select('customers.*, count(invoices) as invoices_count')
      .joins(:transactions)
      .where(transactions: {result: 'success'})
      .group(:id)
      .order('invoices_count DESC')
      .limit(1)
      .first
  end
end
