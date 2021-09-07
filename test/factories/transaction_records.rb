FactoryBot.define do
  factory :transaction_record, class: 'TransactionRecord' do
    association :buyer, factory: :user
    association :broker, factory: :user
    association :stock
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    quantity { Faker::Number.within(range: 10_000..100_000) }
  end
end
