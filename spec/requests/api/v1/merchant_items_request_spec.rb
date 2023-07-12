require 'rails_helper'

RSpec.describe "Merchant Items API" do
  it "sends all items for a given merchant" do
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant_id: merchant_1.id)
    item_2 = create(:item, merchant_id: merchant_1.id)
    item_3 = create(:item, merchant_id: merchant_1.id)
    item_4 = create(:item, merchant_id: merchant_1.id)
    item_5 = create(:item, merchant_id: merchant_1.id)

    get "/api/v1/merchants/#{merchant_1.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(5)

    items.each do |item|
      expect(item.last.first).to have_key(:id)
      expect(item.last.first[:id].to_i).to be_an(Integer)

      expect(item.last.first[:attributes]).to have_key(:name)
      expect(item.last.first[:attributes][:name]).to be_an(String)

      expect(item.last.first[:attributes]).to have_key(:description)
      expect(item.last.first[:attributes][:description]).to be_an(String)

      expect(item.last.first[:attributes]).to have_key(:unit_price)
      expect(item.last.first[:attributes][:unit_price]).to be_an(Float)
    end
  end
end