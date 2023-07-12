require 'rails_helper'

RSpec.describe "Items Search API" do
  describe 'happy path' do
    it 'returns all Items based on search criteria' do
      merchant_id = create(:merchant).id

      item_1 = create(:item, name: "Flat-Head Screwdrivers", merchant_id: merchant_id)
      item_2 = create(:item, name: "Spanner Screwdrivers", merchant_id: merchant_id)
      item_3 = create(:item, name: "Phillips Head Screwdrivers", merchant_id: merchant_id)
      item_4 = create(:item, name: "Hamemr", merchant_id: merchant_id)

      get '/api/v1/items/find_all?name=CrEw'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items_response = JSON.parse(response.body, symbolize_names: true)
      
      items_response[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_an(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_an(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price].to_f).to be_an(Float)
      end

      expect(items_response[:data][0][:attributes][:name]).to eq(item_1.name)
      expect(items_response[:data][1][:attributes][:name]).to eq(item_3.name)
      expect(items_response[:data][2][:attributes][:name]).to eq(item_2.name)

      expect(items_response[:data][0][:attributes][:name]).to_not eq(item_4.name)
      expect(items_response[:data][1][:attributes][:name]).to_not eq(item_4.name)
      expect(items_response[:data][2][:attributes][:name]).to_not eq(item_4.name)
    end
  end
end