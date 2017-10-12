FactoryGirl.define do
  factory :user do
    trait :name_none do
      name nil
      email 'example@example.com'
      password 'examplepassword'
      password_confirmation 'examplepassword'
    end
    trait :name_example do
      name "example user"
      email 'example@example.com'
      password 'examplepassword'
      password_confirmation 'examplepassword'
    end
    trait :over_max_email do
      name "example user"
      email 'a' * 255 + '@example.com'
      password 'examplepassword'
      password_confirmation 'examplepassword'
    end
    trait :under_min_password do
      name "example user"
      email 'example@example.com'
      password 'a' * 5
      password_confirmation 'a' * 5
    end
    trait :password_blank do
      name "example user"
      email 'example@example.com'
      password nil
      password_confirmation nil
    end
  end
end
