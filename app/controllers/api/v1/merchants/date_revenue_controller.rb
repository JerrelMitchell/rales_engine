class Api::V1::Merchants::DateRevenueController < ApplicationController
  def show
    render json: Merchant.date_revenue(params[:date])
  end
end
