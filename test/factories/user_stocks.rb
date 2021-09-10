FactoryBot.define do
  factory :user_stock, class: 'User_Stock' do
    association :user
    association :stock
    average_price { stock.last_transaction_price }
    total_shares { stock.quantity }
  end
end
