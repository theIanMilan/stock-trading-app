FactoryBot.define do
  factory :user_stock, class: 'User_Stock' do
    association :user
    association :stock
    average_price { 100 }
    total_shares { 1_000 }
  end
end
