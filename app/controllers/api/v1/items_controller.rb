class Api::V1::ItemsController < ApplicationController
  # before_action :find_merchant, only: [:update]

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    created_item = Item.create(item_params)
    render json: ItemSerializer.new(created_item), status: :created
  end

  def update
    # require 'pry'; binding.pry
    updated_item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(updated_item), status: 202
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

    # def find_merchant
    #   @merchant = Merchant.find(params[:item][:merchant_id])
    #     if @merchant == nil
    #       error_object = Error.new("Invalid Search Keyword", "404")
    #       render json: ErrorSerializer.serialize_error(error_object), status: error_object.status_code
    #     end
    # end
end