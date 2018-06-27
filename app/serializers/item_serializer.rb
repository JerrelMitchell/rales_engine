class ItemSerializer < ActiveModel::Serializer
  include ActionView::Helpers::NumberHelper

  attributes :id, :name, :description, :unit_price, :merchant_id

  def unit_price
    Money.new(object.unit_price, "USD").to_s
  end
end
