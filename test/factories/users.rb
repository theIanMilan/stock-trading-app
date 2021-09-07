FactoryBot.define do
  factory :user, class: 'User' do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    username { "#{Faker::Number.number(digits: 5)}#{Faker::Name.first_name}" }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    role { 'buyer' }
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
    to_create do |instance|
      # Skip specific after_create callback
      instance.class.skip_callback(:create, :after, :register_as_broker)
      instance.save(validate: false)
    end
    role { 'broker' }
    broker_status { 'approved' }
  end
end
