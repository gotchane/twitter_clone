FactoryGirl.define do
  factory :user do
    name "example user"
    email 'example@example.com'
    password 'examplepassword'
    password_confirmation 'examplepassword'
    trait :bob do
      name "Bob"
      email 'bob@example.com'
    end

    trait :alice do
      name "Alice"
      email 'alice@example.com'
    end

    trait :carol do
      name "Carol"
      email 'carol@example.com'
    end
  end
end
