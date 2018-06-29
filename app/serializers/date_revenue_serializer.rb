class DateRevenueSerializer < ActiveModel::Serializer
  attributes :total_revenue

  def total_revenue
    Money.new(object, "USD").to_s
  end
end
