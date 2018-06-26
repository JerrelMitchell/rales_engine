class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      render json: Merchant.find(params[:merchant_id]).items
    else
      render json: Item.all
    end
  end

  def show
    render json: Item.find(params[:id])
  end
end
