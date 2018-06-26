class ItemSerializer < ActiveModel::Serializer
  include ActionView::Helpers::NumberHelper

  attributes :id, :name, :description, :unit_price, :merchant_id


  def unit_price
    object.unit_price.to_s.insert(-3, '.')
  end
end
