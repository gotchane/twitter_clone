FactoryGirl.define do
  factory :user do
    name "example user"
    email 'example@example.com'
    password 'examplepassword'
    password_confirmation 'examplepassword'
  end
end
