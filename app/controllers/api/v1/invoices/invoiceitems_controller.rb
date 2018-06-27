class Api::V1::Invoices::InvoiceitemsController < ApplicationController
  def index
    render json: Invoice.find(params[:invoice_id]).invoice_items
  end
end
