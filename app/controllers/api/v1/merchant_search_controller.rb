class Api::V1::MerchantSearchController < ApplicationController
  before_action :find_merchant
  before_action :find_merchants

  def index
    render json: MerchantSerializer.new(@merchants)
  end

  def show
    render json: MerchantSerializer.new(@merchant)
  end

  private

    def find_merchant
      @merchant = Merchant.find_merchant_search(params[:name])
        if @merchant == nil
          error_object = Error.new("Invalid Search Keyword", "404")
          render json: ErrorSerializer.serialize_error(error_object), status: error_object.status_code
        end
    end

    def find_merchants
      @merchants = Merchant.find_merchants_search(params[:name])
        if @merchants == nil
          error_object = Error.new("Invalid Search Keyword", "404")
          render json: ErrorSerializer.serialize_error(error_object), status: error_object.status_code
        end
    end
end