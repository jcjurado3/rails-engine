class Api::V1::MerchantSearchController < ApplicationController
  before_action :find_merchant

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
end