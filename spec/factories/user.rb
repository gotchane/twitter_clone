FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}"  }
    sequence(:email) { |n| "example#{n}@example.com" }
    password 'examplepassword'
    password_confirmation 'examplepassword'
  end
end
