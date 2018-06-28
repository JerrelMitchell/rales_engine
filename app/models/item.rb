class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.best_sellers(quantity)
    select("items.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
      .joins(:invoice_items, :invoices, :transactions)
      .where(transactions: { result: "success" })
      .order("revenue DESC")
      .group(:id)
      .limit(quantity)
  end

  def self.most_items(params)
    if params.keys.first != 'quantity'
      return { "error" => "Input '?quantity=<NUMBER>' to search NUMBER of most successfully sold items" }
    end
    joins(:invoice_items)
      .order('SUM(invoice_items.quantity) DESC')
      .group(:id)
      .limit(params[:quantity])
  end
end
