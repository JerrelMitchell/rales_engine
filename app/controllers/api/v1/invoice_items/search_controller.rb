class Api::V1::InvoiceItems::SearchController < ApplicationController
  def show
    render json: InvoiceItem.find_by(search_params)
  end

  def index
    if params[:unit_price]
      render json: InvoiceItem.find_by(unit_price: (params[:unit_price].delete('.')))
    else
      render json: InvoiceItem.where(search_params)
    end
  end

  private

  def search_params
    params.permit(:id, :item_id, :invoice_id, :unit_price, :quantity, :created_at, :updated_at)
  end
end
