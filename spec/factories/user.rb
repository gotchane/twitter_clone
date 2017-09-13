FactoryGirl.define do
  factory :user do
    trait :name_none do
      name nil
    end
    trait :name_example do
      name "example user"
    end
    email 'example@example.com'
    password 'examplepassword'
    password_confirmation 'examplepassword'
  end
end
