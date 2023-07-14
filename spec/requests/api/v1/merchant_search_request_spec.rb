require 'rails_helper'

RSpec.describe "Merchant Search API" do
  describe 'happy path' do
    it 'returns one Merchant based on search criteria' do
      merchant_1 = create(:merchant, name: 'Ace Hardware')
      merchant_2 = create(:merchant, name: 'Carls Hardware')
      merchant_3 = create(:merchant, name: 'Lowes Hardware')


      get '/api/v1/merchants/find?name=har'

      expect(response).to be_successful
      expect(response.status).to eq(200)


      merchant_response = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_response[:data][:attributes]).to have_key(:name)
      expect(merchant_response[:data][:attributes][:name]).to eq(merchant_1.name)
    end

    it 'returns All Merchants based on search criteria' do
      merchant_1 = create(:merchant, name: 'Ace Hardware')
      merchant_2 = create(:merchant, name: 'Carls Hardware')
      merchant_3 = create(:merchant, name: 'Lowes Hardware')


      get '/api/v1/merchants/find_all?name=har'

      expect(response).to be_successful
      expect(response.status).to eq(200)


      merchants_response = JSON.parse(response.body, symbolize_names: true)

      expect(merchants_response[:data].first.count).to eq(3)
      expect(merchants_response[:data][0][:attributes][:name]).to eq(merchant_1.name)
      expect(merchants_response[:data][1][:attributes][:name]).to eq(merchant_2.name)
      expect(merchants_response[:data][2][:attributes][:name]).to eq(merchant_3.name)


    end
  end

  context 'Sad Path' do
    it 'returns 404 - single merchant' do
      get '/api/v1/merchants/find?name=NOMATCH'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors][0][:detail]).to eq("Invalid Search Keyword")
    end

    it 'returns 404 - all merchant' do

      get '/api/v1/merchants/find_all?name=NOMATCH'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors][0][:detail]).to eq("Invalid Search Keyword")
    end
  end
end