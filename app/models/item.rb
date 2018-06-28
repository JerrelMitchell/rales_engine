class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :transactions, through: :invoices
  has_many :invoices, through: :invoice_items

  def self.best_sellers(quantity)
    select("items.*, sum(invoice_items.unit_price * invoice_items.quantity) AS revenue")
      .joins(invoices: [:invoice_items, :transactions])
      .where(transactions: { result: "success"} )
      .group(:id)
      .order("revenue DESC")
      .limit(quantity)
  end

  def self.most_items(quantity)
    joins(:invoices, invoices: [:transactions])
      .merge(Transaction.unscoped.successful)
      .group(:id)
      .order('SUM(invoice_items.quantity) DESC')
      .limit(quantity)
  end
end
