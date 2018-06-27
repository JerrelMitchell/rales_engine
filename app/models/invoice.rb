class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items


  def transactions
    Transaction.where(invoice_id: id)
  end
end
