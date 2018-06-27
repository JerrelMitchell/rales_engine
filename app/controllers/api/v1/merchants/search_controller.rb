class Api::V1::Merchants::SearchController < ApplicationController

  def show
    render json: Merchant.search_result(search_params)
  end

  def index
    render json: Merchant.search_results(search_params)
  end

  private

  def search_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
