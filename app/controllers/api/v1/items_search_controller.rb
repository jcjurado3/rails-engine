class Api::V1::ItemsSearchController < ApplicationController
  def index
    name = params[:name]
    found_items = Item.find_items_search(name)
    render json: ItemSerializer.new(found_items)
  end
end