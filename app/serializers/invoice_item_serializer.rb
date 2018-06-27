class InvoiceItemSerializer < ActiveModel::Serializer
  attributes :id, :item_id, :invoice_id, :unit_price, :quantity

  def unit_price
    Money.new(object.unit_price, "USD").to_s
  end
end
