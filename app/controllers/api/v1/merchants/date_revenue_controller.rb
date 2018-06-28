class Api::V1::Merchants::DateRevenueController < ApplicationController
  def show
    revenue = Merchant.date_revenue(params[:date].to_date)
    render json: { revenue: Money.new(revenue, "USD").to_s }
  end
end
