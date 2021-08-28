FactoryBot.define do
  factory :user, class: 'User' do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    username { "#{Faker::Number.number(digits: 5)}#{Faker::Name.first_name}" }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    role { 'buyer' }
  end

  trait :admin do
    email { 'admin@example.com' }
    password { 'password' }
    role { 'admin' }
  end
end
