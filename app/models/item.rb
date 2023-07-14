class Item < ApplicationRecord
  validates_presence_of :name, :unit_price, :description, :merchant_id
  
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.find_items_search(search_keyword)
    Item.where('name ILIKE ?', "%#{search_keyword}%").order(:name)
  end

  def destroy_with_associations
    invoices.destroy_all
    invoice_items.destroy
  end
end
