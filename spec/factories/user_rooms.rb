# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_room do
    user ""
    room ""
    latest_read_message_id ""
    last_history_deleted ""
    available_flag false
  end
end
