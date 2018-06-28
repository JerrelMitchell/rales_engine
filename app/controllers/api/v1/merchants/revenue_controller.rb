 class Api::V1::Merchants::RevenueController < ApplicationController

   def index
     render json: Merchant.most_revenue(params[:quantity])
   end

   def show
     if params[:date]
       revenue =  Merchant.find(params[:merchant_id]).revenue_for_a_date(params[:date].to_date)
     else
       revenue =  Merchant.find(params[:merchant_id]).revenue
     end
     render json: { revenue: Money.new(revenue, "USD").to_s }
   end
 end
