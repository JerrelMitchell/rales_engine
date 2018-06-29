class Api::V1::Items::SearchController < ApplicationController
  def show
    if params[:unit_price]
      render json: Item.find_by(unit_price: stripped_unit_price)
    else
      render json: Item.order(:id).find_by(search_params)
    end
  end

  def index
    render json: Item.where(search_params)
  end

  private

  def search_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end
