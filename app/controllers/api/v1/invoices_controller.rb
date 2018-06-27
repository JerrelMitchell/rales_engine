class Api::V1::InvoicesController < ApplicationController
  def index
    if params[:merchant_id]
      render json: Merchant.find(params[:merchant_id]).invoices
    else
      render json: Invoice.all
    end
  end

  def show
    render json: Invoice.find(params[:id])
  end
end
