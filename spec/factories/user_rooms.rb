# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_room do
    room_id 1
    user_id 1
    latest_read_message_id ""
    last_history_deleted ""
    available_flag true

    trait :first_room_bob do
      room_id 1
      user_id 1
    end

    trait :first_room_alice do
      room_id 1
      user_id 2
    end

    trait :second_room_bob do
      room_id 2
      user_id 1
    end

    trait :second_room_carol do
      room_id 2
      user_id 3
    end
  end
end
