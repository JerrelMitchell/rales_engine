class Api::V1::Invoices::MerchantsController < ApplicationController
  def show
    render json: Merchant.find(Invoice.find(params[:invoice_id]).merchant_id)
  end
end
