class Api::V1::Merchants::SearchController < ApplicationController

  def show
    render json: Merchant.find_by(name: params[:name])
  end

  def index
    render json: Merchant.where(name: params[:name])
  end


end
