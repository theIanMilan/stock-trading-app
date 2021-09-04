class TransactionRecord < ApplicationRecord
  belongs_to :broker, class_name: 'User', dependent: :destroy
  belongs_to :buyer, class_name: 'User', dependent: :destroy
end
