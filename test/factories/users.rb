FactoryBot.define do
  factory :user, class: 'User' do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    username { "#{Faker::Number.number(digits: 5)}#{Faker::Name.first_name}" }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    role { 'buyer' }
    balance { 5_000 }

    # Skips specific callback when building
    after(:build) do |user|
      user.class.skip_callback(:create, :after, :register_as_broker, raise: false)
    end
  end

  trait :skip_validations do
    to_create { |instance| instance.save(validate: false) }
  end

  trait :admin do
    email { 'admin@example.com' }
    password { 'password' }
    role { 'admin' }
  end

  trait :buyer do
    role { 'buyer' }
  end

  trait :broker do
    role { 'broker' }
    broker_status { 'approved' }
  end
end
