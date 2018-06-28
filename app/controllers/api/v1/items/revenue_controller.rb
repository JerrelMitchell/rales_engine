class Api::V1::Items::RevenueController < ApplicationController
  def index
    render json: Item.best_sellers(search_params[:quantity])
  end

  private

  def search_params
    params.permit(:quantity)
  end
end
