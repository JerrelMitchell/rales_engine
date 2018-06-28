class ItemSerializer < ActiveModel::Serializer

  attributes :id, :name, :description, :unit_price, :merchant_id

  def unit_price
    Money.new(object.unit_price, "USD").to_s
  end
end
