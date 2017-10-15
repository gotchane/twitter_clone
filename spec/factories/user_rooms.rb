# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_room do
    room_id 1
    user_id 1
    latest_read_message_id ""
    last_history_deleted ""
    available_flag true
  end
end
