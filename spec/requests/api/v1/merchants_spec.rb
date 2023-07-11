require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe 'happy path' do
    it "sends a list of all Merchants" do
      create_list(:merchant, 15)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants_data = JSON.parse(response.body, symbolize_names: true)
      merchants = merchants_data[:data]
      
      expect(merchants.count).to eq(15)

      merchants.each do |merchant|
        expect(merchant[:attributes]).to have_key(:id)
        expect(merchant[:attributes][:id]).to be_an(Integer)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_an(String)
      end

      # expect(merchants.first[:name]).to eq("Abbott-Heidenreich")<- need to figure out a way to test for attribute name. 
    end

    it "sends one merchant by :id" do
      id = create(:merchant).id
      
      merchant = Merchant.find(id)

      get "/api/v1/merchants/#{id}"

      expect(response).to be_successful

      merchant_response = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_response).to have_key(:id)
      expect(merchant_response[:id]).to eq(id)

      expect(merchant_response).to have_key(:name)
      expect(merchant_response[:name]).to eq(merchant.name)
    end
  end
end