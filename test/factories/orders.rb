FactoryBot.define do
  factory :order, class: 'Order' do
    association :user
    association :stock
    transaction_type { 'sell' }
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    quantity { Faker::Number.within(range: 10..100) }
  end
end
