class Api::V1::InvoiceItems::RandomController < ApplicationController
  def show
    render json: InvoiceItem.find(InvoiceItem.all.sample.id)
  end
end
