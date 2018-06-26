class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :unit_price

  belongs_to :merchant
end
