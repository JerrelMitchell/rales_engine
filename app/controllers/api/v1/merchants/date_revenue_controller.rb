class Api::V1::Merchants::DateRevenueController < ApplicationController
  def show
    render json: Merchant.date_revenue(params[:date].to_date), serializer: DateRevenueSerializer
  end
end
