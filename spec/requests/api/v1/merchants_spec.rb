require 'rails_helper'

describe 'Merchants API' do
  it "sends a list of all Merchants" do
    create_list(:merchant, 15)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(15)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_an(String)
    end

    # expect(merchants.first[:name]).to eq("Abbott-Heidenreich")<- need to figure out a way to test for attribute name. 
  end

  it "can get one merchant by :id" do
    id = create(:merchant).id
    merchant = Merchant.find(id)

    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful

    merchant_response = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_response).to have_key(:id)
    expect(merchant_response).to have_key(:name)


    expect(merchant_response[:name]).to eq(merchant.name)
  end
end