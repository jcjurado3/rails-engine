class Api::V1::MerchantSearchController < ApplicationController
  before_action :find_merchant
  before_action :find_merchants

  def index
    render json: MerchantSerializer.new(@merchants)
  end

  def show
    render json: MerchantSerializer.new(@merchant)
  end


end