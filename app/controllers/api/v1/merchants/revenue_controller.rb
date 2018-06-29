 class Api::V1::Merchants::RevenueController < ApplicationController
   def index
     render json: Merchant.most_revenue(params[:quantity])
   end

   def show
     if params[:date]
       render json: Merchant.find(params[:merchant_id]).revenue_for_a_date(params[:date].to_date), serializer: RevenueSerializer
     else
       render json: Merchant.find(params[:merchant_id]).revenue, serializer: RevenueSerializer
     end
   end
 end
