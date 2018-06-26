class Api::V1::Items::InvoiceItemsController < ApplicationController
  def index
    render json: Item.find_by(params[:id]).invoice_items
  end
end
