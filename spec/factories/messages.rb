# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    body "This is a test message"
    #room_id 1
    #user_id 1
    room
    user
  end
end
