class Merchant < ApplicationRecord
  # validates :name, presence: true
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.find_merchant_search(search_keyword)
    merchant = Merchant.where('name ILIKE ?', "%#{search_keyword}%").order(:name).first
  end

  def self.find_merchants_search(search_keyword)
    merchant = Merchant.where('name ILIKE ?', "%#{search_keyword}%").order(:name)
  end
end