require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe 'happy path' do
    it "sends a list of all Merchants" do
      create_list(:merchant, 15)

      get '/api/v1/merchants'

      expect(response).to be_successful
      expect(response.status).to eq(200)


      merchants_data = JSON.parse(response.body, symbolize_names: true)
      merchants = merchants_data[:data]
      
      expect(merchants.count).to eq(15)

      merchants.each do |merchant|
        
        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to be_an(Integer)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_an(String)
      end
    end

    it "sends one merchant by :id" do
      id = create(:merchant).id
      
      merchant = Merchant.find(id)

      get "/api/v1/merchants/#{id}"

      expect(response).to be_successful

      merchant_response = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_response[:data]).to have_key(:id)
      expect(merchant_response[:data][:id].to_i).to eq(id)

      expect(merchant_response[:data][:attributes]).to have_key(:name)
      expect(merchant_response[:data][:attributes][:name]).to eq(merchant.name)
    end
  end

  describe "Sad Path" do
    it "returns error response" do
      get '/api/v1/merchants/9999999'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      response_data = JSON.parse(response.body, symbolize_names: true)

      expect(response_data).to have_key(:errors)
      expect(response_data[:errors].first[:detail]).to eq("Couldn't find Merchant with 'id'=9999999")
    end
  end
end