class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :merchants, through: :invoices

  def favorite_merchant
    merchants
      .select('merchants.*, COUNT(invoices)as invoices_count')
      .joins(:invoices, :transactions)
      .where(transactions: { result: 'success' })
      .order('invoices_count DESC')
      .group(:id)
      .limit(1)
      .first
  end
end
