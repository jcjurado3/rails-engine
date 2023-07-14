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
  end

  context 'Sad Path' do
    it 'returns 404' do
      get '/api/v1/merchants/find?name=NOMATCH'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors][0][:detail]).to eq("Invalid Search Keyword")
    end
  end
end