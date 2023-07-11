class Api::V1::MerchantItemsController < ApplicationController
  def index
    merchant_items = Merchant.find(params[:merchant_id]).items
    
    render json: ItemSerializer.new(merchant_items)
  end
end