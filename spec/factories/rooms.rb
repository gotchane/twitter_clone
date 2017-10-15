# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :room do
    trait :valid do
      create_user_id 1
    end
    trait :invalid do
      create_user_id nil
    end
  end
end
