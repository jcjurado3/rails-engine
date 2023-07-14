class Api::V1::ItemsSearchController < ApplicationController
  before_action :find_items

  def index
    render json: ItemSerializer.new(@items)
  end
  private

    def find_items
      @items = Item.find_items_search(params[:name])
      # require 'pry'; binding.pry
        if @items == []
          error_object = Error.new("Invalid Search Keyword", "404")
          render json: ErrorSerializer.serialize_error(error_object), status: error_object.status_code
        end
    end
end