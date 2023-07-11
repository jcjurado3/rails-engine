require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'happy path' do
    it 'sends all items' do
      merchant_id = create(:merchant).id

      items = create_list(:item, 10, merchant_id: merchant_id)

      get '/api/v1/items'

      expect(response).to be_successful

      items_data = JSON.parse(response.body, symbolize_names: true)
      items = items_data[:data]

      expect(items.count).to eq(10)

    end
  end
end