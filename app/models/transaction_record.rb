class TransactionRecord < ApplicationRecord
  belongs_to :broker, class_name: 'User', dependent: :destroy, inverse_of: :transaction_records
  belongs_to :buyer, class_name: 'User', dependent: :destroy, inverse_of: :transaction_records
end
