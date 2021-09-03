class Order < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  enum transaction_type: { buy: 0, sell: 1 }
end
