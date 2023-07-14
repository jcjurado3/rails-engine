require 'rails_helper'

RSpec.describe "Items Search API" do
  context 'happy path' do
    feature 'returns all Items based on search criteria' do
      it 'all items response, data type, and attributes' do
        merchant_id = create(:merchant).id

        item_1 = create(:item, name: "Flat-Head Screwdrivers", merchant_id: merchant_id)
        item_2 = create(:item, name: "Spanner Screwdrivers", merchant_id: merchant_id)
        item_3 = create(:item, name: "Phillips Head Screwdrivers", merchant_id: merchant_id)
        item_4 = create(:item, name: "Hamemr", merchant_id: merchant_id)

        get '/api/v1/items/find_all?name=CrEw'

        expect(response).to be_successful
        expect(response.status).to eq(200)

        items_response = JSON.parse(response.body, symbolize_names: true)

        expect(items_response[:data].count).to eq(3)    
        items_response[:data].each do |item|
          
          expect(item).to have_key(:id)
          expect(item[:id].to_i).to be_an(Integer)
          item = item[:attributes]
          expect(item).to have_key(:name)
          expect(item[:name]).to be_an(String)

          expect(item).to have_key(:description)
          expect(item[:description]).to be_an(String)

          expect(item).to have_key(:unit_price)
          expect(item[:unit_price].to_f).to be_an(Float)
        end

        expect(items_response[:data][0][:attributes][:name]).to eq(item_1.name)
        expect(items_response[:data][0][:attributes][:description]).to eq(item_1.description)
        expect(items_response[:data][0][:attributes][:unit_price]).to eq(item_1.unit_price)

        expect(items_response[:data][1][:attributes][:name]).to eq(item_3.name)
        expect(items_response[:data][1][:attributes][:description]).to eq(item_3.description)
        expect(items_response[:data][1][:attributes][:unit_price]).to eq(item_3.unit_price)

        expect(items_response[:data][2][:attributes][:name]).to eq(item_2.name)
        expect(items_response[:data][2][:attributes][:description]).to eq(item_2.description)
        expect(items_response[:data][2][:attributes][:unit_price]).to eq(item_2.unit_price)

        expect(items_response[:data][0][:attributes][:name]).to_not eq(item_4.name)
        expect(items_response[:data][1][:attributes][:name]).to_not eq(item_4.name)
        expect(items_response[:data][2][:attributes][:name]).to_not eq(item_4.name)
      end
    end
  end

  context 'Sad Path' do
    it 'returns 404' do
      get '/api/v1/items/find_all?name=NOMATCH'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end
end