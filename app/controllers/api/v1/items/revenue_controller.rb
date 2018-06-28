class Api::V1::Items::RevenueController < ApplicationController
  def index
    render json: Item.best_sellers(search_params[:quantity])
  end

  private

  def search_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at, :quantity)
  end
end
