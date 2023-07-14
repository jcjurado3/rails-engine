class Item < ApplicationRecord
  # validates :name, presence: true
  
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.find_items_search(search_keyword)
    Item.where('name ILIKE ?', "%#{search_keyword}%").order(:name)
  end
end
