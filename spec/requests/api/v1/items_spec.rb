require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'happy path' do
    it 'sends all items' do
      merchant_id = create(:merchant).id

      items = create_list(:item, 10, merchant_id: merchant_id)
      new_item = create(:item, merchant_id: merchant_id)

      get '/api/v1/items'

      expect(response).to be_successful

      items_data = JSON.parse(response.body, symbolize_names: true)
      items = items_data[:data]

      expect(items.count).to eq(11)

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)
      end

      expect(items.last[:attributes][:name]).to eq(new_item.name)
    end

    it "sends one item" do
      merchant_id = create(:merchant).id

      item_1 = create(:item, merchant_id: merchant_id)
      id_1 = item_1.id

      item_2 = create(:item, merchant_id: merchant_id)
      id_2 = item_2.id

      get "/api/v1/items/#{id_1}"

      expect(response).to be_successful

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(item_data.count).to eq(1)

      expect(item_data[:data]).to have_key(:id)
      expect(item_data[:id].to_i).to be_an(Integer)

      expect(item_data[:data][:attributes]).to have_key(:name)
      expect(item_data[:data][:attributes][:name]).to be_an(String)
      expect(item_data[:data][:attributes][:name]).to eq(item_1.name)
    end

    it "can create an item" do
      merchant_id = create(:merchant).id

      item_params = ({
        name: "iPhone",
        description: "New Age Information Device",
        unit_price: 99999999999.99,
        merchant_id: merchant_id
      })
      header = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: header, params: JSON.generate(item: item_params)

      created_item = Item.last
      
      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end

    it 'can edit existing item' do
      merchant_id = create(:merchant).id

      id = create(:item, merchant_id: merchant_id).id
      previous_name = Item.last.name
      previous_description = Item.last.description
      previous_price = Item.last.unit_price

      item_params = ({
        name: "iPhone",
        description: "New Age Information Device",
        unit_price: 99999999999.99,
        merchant_id: merchant_id
      })
      header = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: header, params: JSON.generate(item: item_params)

      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.description).to_not eq(previous_description)
      expect(item.unit_price).to_not eq(previous_price)
    end

    it "can delete an item" do
      merchant_id = create(:merchant).id

      id = create(:item, merchant_id: merchant_id).id

      expect{ delete "/api/v1/items/#{id}" }.to change(Item, :count).by(-1)

      expect{Item.find(id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end