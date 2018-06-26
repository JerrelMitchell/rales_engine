class Api::V1::Merchants::RandomController < ApplicationController
  def show
    render json: Merchant.find(Merchant.all.sample.id)
  end
end
