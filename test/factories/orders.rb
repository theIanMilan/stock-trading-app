FactoryBot.define do
  factory :order, class: 'Order' do
    association :user
    association :stock
    transaction_type { 'sell' }
    price { stock.last_transaction_price }
    quantity { stock.quantity }
  end

  trait :buying do
    transaction_type { 'buy' }
  end

  trait :selling do
    transaction_type { 'sell' }
  end
end
