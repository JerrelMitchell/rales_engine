class Api::V1::Transactions::SearchController < ApplicationController
   def show
     render json: Transaction.search_result(search_params)
   end

   def index
     render json: Transaction.search_results(search_params)
   end

   private
   def search_params
     params.permit(:id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at)
   end
end
