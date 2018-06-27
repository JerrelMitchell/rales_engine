class Api::V1::Customers::TransactionsController < ApplicationController
  def index
    render json: Customer.find_by(params[:id]).transactions
  end
end
