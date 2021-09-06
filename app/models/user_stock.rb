class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  validates :average_price, numericality: { greater_than: 0 }
  validates :total_shares, numericality: { greater_than: 0 }
end
