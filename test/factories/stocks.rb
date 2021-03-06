FactoryBot.define do
  factory :stock, class: 'Stock' do
    ticker { Faker::Name.initials(number: 3) }
    company_name { Faker::Company.name }
    last_transaction_price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    quantity { Faker::Number.within(range: 10_000..100_000) }
  end

  trait :p10_q100 do
    # For quick rspec transactions
    last_transaction_price { 10 }
    quantity { 100 }
  end
end
