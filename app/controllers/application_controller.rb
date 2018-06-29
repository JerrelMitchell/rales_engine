class ApplicationController < ActionController::API
  def stripped_unit_price
    params[:unit_price].delete('.')
  end
end
