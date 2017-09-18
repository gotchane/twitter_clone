FactoryGirl.define do
  factory :user do
    trait :name_none do
      name nil
      email 'example@example.com'
    end
    trait :name_example do
      name "example user"
      email 'example@example.com'
    end
    trait :over_max_email do
      name "example user"
      email 'a' * 255 + '@example.com'
    end
    password 'examplepassword'
    password_confirmation 'examplepassword'
  end
end
