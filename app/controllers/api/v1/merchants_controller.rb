 class Api::V1::MerchantsController < ApplicationController

   def index
     render json: Merchant.all
   end

   def show
     if params[:item_id]
       render json: Item.find(params[:item_id]).merchant
     else
       render json: Merchant.find(params[:id])
     end
   end
 end
