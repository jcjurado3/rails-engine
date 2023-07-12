class Api::V1::MerchantSearchController < ApplicationController
  def show
    name = params[:name]
    found_merchant = Merchant.find_merchant_search(name)
    render json: MerchantSerializer.new(found_merchant)
  end
end