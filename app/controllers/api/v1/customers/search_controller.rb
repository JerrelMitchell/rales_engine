class Api::V1::Customers::SearchController < ApplicationController
  def show
    render json: Customer.search_result(search_params)
  end

  def index
    render json: Customer.search_results(search_params)

  end

  private
  def search_params
    params.permit(:id, :first_name, :last_name)
  end
end
