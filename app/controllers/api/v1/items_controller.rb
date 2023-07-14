class Api::V1::ItemsController < ApplicationController
  before_action :find_merchant, only: [:update, :create]
  before_action :find_item, only: [:show, :update, :destroy]


  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(@item)
  end

  def create
    created_item = Item.create(item_params)
    render json: ItemSerializer.new(created_item), status: :created
  end

  def update
    updated_item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(updated_item), status: 202
  end

  def destroy
    @item.destroy_with_associations
    render json: Item.delete(params[:id])
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

    def find_merchant
      merchant = Merchant.find(params[:item][:merchant_id])
    end

    def find_item
      @item = Item.find(params[:id])
    end
end