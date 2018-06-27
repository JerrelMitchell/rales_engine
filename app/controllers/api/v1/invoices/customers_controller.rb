class Api::V1::Invoices::CustomersController < ApplicationController

  def show
    render json: Customer.find(Invoice.find(params[:invoice_id]).customer_id)
  end


end
