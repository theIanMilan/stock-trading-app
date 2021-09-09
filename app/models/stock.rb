class Stock < ApplicationRecord
  has_many :user_stocks, dependent: :destroy
  has_many :users, through: :user_stocks
  has_many :orders, dependent: :destroy
  has_many :transaction_records, dependent: :nullify

  validates :ticker,       presence: true,
                           uniqueness: true
  validates :company_name, presence: true,
                           uniqueness: true
  validates :last_transaction_price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than: 0 }

  def update_last_price(price)
    self.last_transaction_price = price
    save!
  end
end
