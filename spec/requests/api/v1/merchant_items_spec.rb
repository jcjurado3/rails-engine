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

    expect(items.count).to eq(5)
  end
end